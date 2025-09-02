import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_status/individu_status_state.dart';
import 'package:attandance_simple/core/service/individu_status_service.dart';

class IndividuStatusCubit extends Cubit<IndividuStatusState> {
  final IndividuStatusService service;
  IndividuStatusCubit(this.service) : super(const IndividuStatusState());

  Future<void> fetchIndividuLomba({required int lombadId}) async {
    emit(state.copyWith(status: DataStatus.loading));
    try {
      final res = await service.getIndividuLomba(lombadId: lombadId);
      if (res.success == true && res.data != null) {
        emit(state.copyWith(status: DataStatus.success, lombaList: res.data!));
      } else {
        throw Exception(res.message ?? 'Gagal memuat data.');
      }
    } catch (e) {
      emit(state.copyWith(status: DataStatus.failure, error: e.toString()));
    }
  }

  Future<void> addIndividuLomba({
    required String nameLomba,
    required int ekskulId,
    required String startDate,
    required String endDate,
    required String status,
    required int lombaId,
  }) async {
    emit(state.copyWith(actionStatus: ActionStatus.loading, clearActionState: true));
    try {
      final res = await service.createIndividuLomba(
        nameLomba: nameLomba,
        ekskulId: ekskulId,
        startDate: startDate,
        endDate: endDate,
        status: status,
        lombadId: lombaId,
      );
      if (res.success == true) {
        emit(state.copyWith(
          actionStatus: ActionStatus.success,
          successMessage: res.message ?? 'Babak berhasil dibuat',
        ));
        await fetchIndividuLomba(lombadId: lombaId);
      } else {
        throw Exception(res.message ?? 'Gagal menambahkan data.');
      }
    } catch (e) {
      emit(state.copyWith(actionStatus: ActionStatus.failure, actionError: e.toString()));
    }
  }

  Future<void> editIndividuLomba({
    required int id,
    required String nameLomba,
    required int ekskulId,
    required String startDate,
    required String endDate,
    required String status,
    required int lombaId,
  }) async {
    emit(state.copyWith(actionStatus: ActionStatus.loading, clearActionState: true));
    try {
      final res = await service.updateIndividuLomba(
        id: id,
        nameLomba: nameLomba,
        ekskulId: ekskulId,
        startDate: startDate,
        endDate: endDate,
        status: status,
      );
      if (res.success == true) {
        emit(state.copyWith(
          actionStatus: ActionStatus.success,
          successMessage: res.message ?? 'Babak berhasil diperbarui',
        ));
        await fetchIndividuLomba(lombadId: lombaId);
      } else {
        throw Exception(res.message ?? 'Gagal memperbarui data.');
      }
    } catch (e) {
      emit(state.copyWith(actionStatus: ActionStatus.failure, actionError: e.toString()));
    }
  }

  Future<void> deleteIndividuLomba(int id, {required int lombaId}) async {
    emit(state.copyWith(actionStatus: ActionStatus.loading, clearActionState: true));
    try {
      final res = await service.deletedIndividuLomba(id);
      if (res.success == true) {
        emit(state.copyWith(
          actionStatus: ActionStatus.success,
          successMessage: res.message ?? 'Babak berhasil dihapus',
        ));
        await fetchIndividuLomba(lombadId: lombaId);
      } else {
        throw Exception(res.message ?? 'Gagal menghapus data.');
      }
    } catch (e) {
      emit(state.copyWith(actionStatus: ActionStatus.failure, actionError: e.toString()));
    }
  }

  void clearActionStatus() => emit(state.copyWith(clearActionState: true));
}
