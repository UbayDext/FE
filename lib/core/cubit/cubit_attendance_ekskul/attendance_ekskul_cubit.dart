import 'package:bloc/bloc.dart';
import 'package:attandance_simple/core/cubit/cubit_attendance_ekskul/attendance_ekskul_state.dart';
import 'package:attandance_simple/core/service/attendance_service.dart';

class AttendanceEkskulCubit extends Cubit<AttendanceEkskulState> {
  final AttendanceService service;
  final String namaEkskul;
  final DateTime selectedDate;
  final int ekskulId;
  final int? classroomId;
  final int? studiId;

  AttendanceEkskulCubit({
    required this.service,
    required this.ekskulId,
    required this.selectedDate,
    required this.namaEkskul,
    this.classroomId,
    this.studiId,
  }) : super(const AttendanceEkskulState());

  Future<void> fetchDaily() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final list = await service.fetchDailyAll(
        ekskulId: ekskulId,
        date: selectedDate,
        studiId: studiId,
        classroomId: classroomId,
      );
      emit(state.copyWith(loading: false, daftar: list));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), daftar: const []));
    }
  }

  Map<String, int> getRekapStatus() {
    final m = {'H': 0, 'I': 0, 'S': 0, 'A': 0};
    for (final s in state.daftar) {
      final st = s.status; // String?
      if (st != null && m.containsKey(st)) m[st] = m[st]! + 1;
    }
    return m;
  }

  Future<void> updateStatus(int studentId, String status) async {
    if (studiId == null) {
      emit(state.copyWith(error: 'studi_id wajib saat upsert (BE validate).'));
      return;
    }

    // optimistic update
    final before = state.daftar;
    final after = before.map((e) {
      if (e.studentId == studentId) return e.copyWith(status: status);
      return e;
    }).toList();
    emit(state.copyWith(daftar: after));

    try {
      await service.upsertStatus(
        studentId: studentId,
        ekskulId: ekskulId,
        date: selectedDate,
        status: status,
        studiId: studiId!,
      );
    } catch (e) {
      emit(state.copyWith(daftar: before, error: e.toString()));
    }
  }

  Future<bool> simpanDataAbsensiEkskul() async {
    emit(state.copyWith(saving: true, error: null));
    try {
      if (studiId == null) throw Exception('studi_id wajib untuk Save All.');

      final items = state.daftar
          .where((e) => (e.status ?? '').isNotEmpty && e.studentId != null)
          .map<({int studentId, int ekskulId, DateTime date, String status, int studiId})>(
            (e) => (
              studentId: e.studentId!,
              ekskulId: ekskulId,
              date: selectedDate,
              status: e.status!, // aman karena disaring di atas
              studiId: studiId!,
            ),
          )
          .toList();

      if (items.isNotEmpty) {
        await service.upsertBulk(items);
      }
      emit(state.copyWith(saving: false));
      return true;
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
      return false;
    }
  }
}
