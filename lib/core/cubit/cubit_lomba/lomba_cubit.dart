import 'package:attandance_simple/core/cubit/cubit_lomba/lomba_state.dart';
import 'package:attandance_simple/core/models/lomba/deletedlomba.dart';
import 'package:attandance_simple/core/models/lomba/postlomba.dart';
import 'package:attandance_simple/core/models/lomba/putlomba.dart';
import 'package:attandance_simple/core/service/Lomba_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LombaCubit extends Cubit<LombaState> {
  final LombaService service;

  LombaCubit(this.service) : super(const LombaState());

  /// Ambil data awal (lomba + ekskul)
Future<void> fetchInitialData() async {
  emit(state.copyWith(status: LombaStatus.loading));
  try {
    final lombaResult = await service.getAllLomba(); // return GetLombaPub
    final ekskulResult = await service.getAllEkskul(); // return List<EkskulGet>

    emit(
      state.copyWith(
        status: LombaStatus.success,
        lombaList: lombaResult.data ?? [], // ✅ List<Datum>
        availableEkskuls: ekskulResult,
      ),
    );
  } catch (e) {
    emit(state.copyWith(status: LombaStatus.failure, error: e.toString()));
  }
}
  /// Tambah lomba
  Future<void> addLomba({
    required String name,
    required String status,
    required int ekskulId,
  }) async {
    emit(state.copyWith(actionStatus: LombaActionStatus.loading, clearActionState: true));
    try {
      final Postlomba result = await service.createLomba(
        name: name,
        status: status,
        ekskulId: ekskulId,
      );
      emit(state.copyWith(
        actionStatus: LombaActionStatus.success,
        successMessage: 'Lomba "${result.name}" berhasil ditambahkan.',
      ));
      await fetchInitialData(); // 🔥 refresh semua data
    } catch (e) {
      emit(state.copyWith(actionStatus: LombaActionStatus.failure, actionError: e.toString()));
    }
  }

  /// Edit lomba
  Future<void> editLomba({
    required int id,
    required String name,
    required String status,
    required int ekskulId,
  }) async {
    emit(state.copyWith(actionStatus: LombaActionStatus.loading, clearActionState: true));
    try {
      final Putlomba result = await service.updateLomba(
        id: id,
        name: name,
        status: status,
        ekskulId: ekskulId,
      );
      emit(state.copyWith(
        actionStatus: LombaActionStatus.success,
        successMessage: 'Lomba "${result.name}" berhasil diperbarui.',
      ));
      await fetchInitialData(); // 🔥 refresh semua data
    } catch (e) {
      emit(state.copyWith(actionStatus: LombaActionStatus.failure, actionError: e.toString()));
    }
  }

  /// Hapus lomba
  Future<void> removeLomba(int id) async {
    emit(state.copyWith(actionStatus: LombaActionStatus.loading, clearActionState: true));
    try {
      final Deletedlomba result = await service.deleteLomba(id);
      emit(state.copyWith(
        actionStatus: LombaActionStatus.success,
        successMessage: result.message ?? 'Lomba berhasil dihapus.',
      ));
      await fetchInitialData(); // 🔥 refresh semua data
    } catch (e) {
      emit(state.copyWith(actionStatus: LombaActionStatus.failure, actionError: e.toString()));
    }
  }
}
