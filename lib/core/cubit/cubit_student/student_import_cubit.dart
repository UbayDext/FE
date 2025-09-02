import 'dart:io';
import 'package:attandance_simple/core/service/Students_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'student_import_state.dart';

class StudentImportCubit extends Cubit<StudentImportState> {
  final StudentService service;
  StudentImportCubit(this.service) : super(StudentImportInitial());
  Future<void> fetchStudents({
    int? classId,
    int? ekskulId,
    int? studiId,
  }) async {
    emit(StudentLoading());
    try {
      final result = await service.getStudents(
        classId: classId,
        ekskulId: ekskulId,
        studiId: studiId,
      );
      emit(StudentListLoaded(result));
    } on DioException catch (e) {
      emit(
        StudentError(
          'DIO [${e.response?.statusCode}] ${e.response?.data ?? e.message}',
        ),
      );
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> importStudentsFromBytes(
    List<int> bytes, {
    String? filename,
    int? studiId,
  }) async {
    emit(StudentLoading());
    try {
      final result = await service.importStudent(
        File('dummy.xlsx'), // dummy file, tidak dipakai karena kita kirim bytes
        bytes: bytes,
        filename: filename,
        studiId: studiId,
      );
      emit(StudentImportSuccess(result));
    } catch (e) {
      emit(StudentError('Gagal import siswa: $e'));
    }
  }

  Future<void> importStudents(File file) async {
    emit(StudentLoading());
    try {
      final result = await service.importStudent(file);
      emit(StudentImportSuccess(result));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> addStudent(Map<String, dynamic> data) async {
    emit(StudentLoading());
    try {
      final result = await service.addStudent(data);
      emit(StudentAddSuccess(result));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> updateStudent(int id, Map<String, dynamic> data) async {
    emit(StudentLoading());
    try {
      final result = await service.updateStudent(id, data);
      emit(StudentUpdateSuccess(result));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> deleteStudent(int id) async {
    emit(StudentLoading());
    try {
      final result = await service.deleteStudent(id);
      emit(StudentDeleteSuccess(result));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> addManyStudents(
    List<Map<String, dynamic>> payload, {
    required int classId,
    required int studiId,
  }) async {
    emit(StudentLoading());
    try {
      final result = await service.addManyStudents(payload);
      emit(StudentImportSuccess(result));
      

      // setelah sukses, auto refresh list
      await Future.delayed(const Duration(milliseconds: 300));
      final list = await service.getStudents(
        classId: classId,
        studiId: studiId,
      );
      emit(StudentListLoaded(list));
    } on DioException catch (e) {
      emit(
        StudentError(
          'DIO [${e.response?.statusCode}] ${e.response?.data ?? e.message}',
        ),
      );
    } catch (e) {
      emit(StudentError('Gagal tambah siswa: $e'));
    }
  }
}
