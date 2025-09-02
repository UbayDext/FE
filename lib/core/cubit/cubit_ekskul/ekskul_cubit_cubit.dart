import 'package:attandance_simple/core/cubit/cubit_ekskul/ekskul_cubit_state.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_post.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_put.dart';
import 'package:attandance_simple/core/service/Ekskul_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EkskulCubitCubit extends Cubit<EkskulCubitState> {
  final EkskulService service;
  EkskulCubitCubit(this.service) : super(EkskulInitial());

  /// Ambil semua ekskul
  Future<void> fetchEkskul({int? studiId}) async {
    emit(EkskulLoading());
    try {
      final data = await service.fetchEkskul(studiId: studiId);
      emit(EkskulLoaded(data));
    } catch (e) {
      emit(EkskulError(e.toString()));
    }
  }

  /// Tambah ekskul
  Future<void> createEkskul(EkskulPost data, {int? studiId}) async {
    emit(EkskulLoading());
    try {
      await service.createEkskul(data);
      // langsung refresh
      final updated = await service.fetchEkskul(studiId: studiId);
      emit(EkskulLoaded(updated));
    } catch (e) {
      emit(EkskulError(e.toString()));
    }
  }

  /// Update ekskul
  Future<void> updateEkskul(int id, EkskulPut data, {int? studiId}) async {
    emit(EkskulLoading());
    try {
      await service.updateEkskul(id, data);
      // langsung refresh
      final updated = await service.fetchEkskul(studiId: studiId);
      emit(EkskulLoaded(updated));
    } catch (e) {
      emit(EkskulError(e.toString()));
    }
  }

  /// Hapus ekskul
  Future<void> deleteEkskul(int id, {int? studiId}) async {
    emit(EkskulLoading());
    try {
      await service.deleteEkskul(id);
      // langsung refresh
      final updated = await service.fetchEkskul(studiId: studiId);
      emit(EkskulLoaded(updated));
    } catch (e) {
      emit(EkskulError(e.toString()));
    }
  }
}
