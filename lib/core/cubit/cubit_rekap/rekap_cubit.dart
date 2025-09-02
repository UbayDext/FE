import 'package:bloc/bloc.dart';
import 'rekap_state.dart';
import 'package:attandance_simple/core/service/rekap_service.dart';

class RekapCubit extends Cubit<RekapState> {
  final RekapService service;
  final int ekskulId;
  final int studiId;
  final int? classroomId;

  RekapCubit({
    required this.service,
    required this.ekskulId,
    required this.studiId,
    required this.classroomId,
    DateTime? initialDate,
  }) : super(RekapState(selectedDate: initialDate ?? DateTime.now()));

  // expose id buat navigasi ke screen presensi
  int get gEkskulId => ekskulId;
  int? get gClassroomId => classroomId;
  int get gStudiId => studiId;

  void setDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    fetch();
  }

  Future<void> fetch() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final r = await service.getDailyRekap(
        ekskulId: ekskulId,
        tanggal: state.selectedDate,
        studiId: studiId,
        classroomId: classroomId,
      );
      emit(state.copyWith(
        loading: false,
        h: r.h, i: r.i, s: r.s, a: r.a,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
        h: 0, i: 0, s: 0, a: 0,
      ));
    }
  }
}
