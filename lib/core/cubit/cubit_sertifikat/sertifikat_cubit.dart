import 'dart:io';
import 'package:attandance_simple/core/cubit/cubit_sertifikat/sertifikat_state.dart';
import 'package:attandance_simple/core/service/Sertifikation_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikat_get/datum.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikat_get/sertifikat_get.dart';



class SertifikatCubit extends Cubit<SertifikatState> {
  final SertifikationService service;
  SertifikatCubit(this.service) : super(const SertifikatState());

  Future<void> fetch({
    required int studentId,
    int? studiId,
    int? ekskulId,
    int? classroomId,
    bool silent = false,
  }) async {
    if (!silent) {
      emit(state.copyWith(
        loading: true,
        error: null,
        lastAction: 'fetch',
        successMessage: null,
      ));
    }
    try {
      final res = await service.getByStudent(
        studentId: studentId,
        studiId: studiId,
        ekskulId: ekskulId,
        classroomId: classroomId,
      );
      emit(state.copyWith(
        loading: false,
        list: res.data ?? const [],
        lastAction: silent ? state.lastAction : 'fetch',
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'DIO [${e.response?.statusCode}] ${e.response?.data ?? e.message}',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> create({
    required String title,
    required int studentId,
    int? studiId,
    int? ekskulId,
    int? classroomId,
    required File file,
  }) async {
    emit(state.copyWith(loading: true, error: null, lastAction: 'create', successMessage: null));
    try {
      await service.create(
        title: title,
        studentId: studentId,
        studiId: studiId,
        ekskulId: ekskulId,
        classroomId: classroomId,
        file: file,
      );

      // announce success first -> biar dialog bisa close
      emit(state.copyWith(
        loading: false,
        lastAction: 'create',
        successMessage: 'Sertifikat ditambahkan',
      ));

      // then silent refresh
      await fetch(
        studentId: studentId,
        studiId: studiId,
        ekskulId: ekskulId,
        classroomId: classroomId,
        silent: true,
      );
    } on DioException catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'DIO [${e.response?.statusCode}] ${e.response?.data ?? e.message}',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> update({
    required int id,
    required int studentId,
    String? title,
    int? studiId,
    int? ekskulId,
    int? classroomId,
    File? file,
  }) async {
    emit(state.copyWith(loading: true, error: null, lastAction: 'update', successMessage: null));
    try {
      await service.update(
        id: id,
        title: title,
        studentId: studentId,
        studiId: studiId,
        ekskulId: ekskulId,
        classroomId: classroomId,
        file: file,
      );

      emit(state.copyWith(
        loading: false,
        lastAction: 'update',
        successMessage: 'Sertifikat diperbarui',
      ));

      await fetch(
        studentId: studentId,
        studiId: studiId,
        ekskulId: ekskulId,
        classroomId: classroomId,
        silent: true,
      );
    } on DioException catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'DIO [${e.response?.statusCode}] ${e.response?.data ?? e.message}',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> remove({
    required int id,
    required int studentId,
    int? studiId,
    int? ekskulId,
    int? classroomId,
  }) async {
    emit(state.copyWith(loading: true, error: null, lastAction: 'delete', successMessage: null));
    try {
      await service.delete(id);

      emit(state.copyWith(
        loading: false,
        lastAction: 'delete',
        successMessage: 'Sertifikat dihapus',
      ));

      await fetch(
        studentId: studentId,
        studiId: studiId,
        ekskulId: ekskulId,
        classroomId: classroomId,
        silent: true,
      );
    } on DioException catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'DIO [${e.response?.statusCode}] ${e.response?.data ?? e.message}',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
  
}
