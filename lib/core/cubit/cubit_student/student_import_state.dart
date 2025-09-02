import 'package:attandance_simple/core/models/students/deleted_student_public.dart';
import 'package:attandance_simple/core/models/students/get_student_public/get_student_public.dart';
import 'package:attandance_simple/core/models/students/post_student_public/post_student_public.dart';
import 'package:attandance_simple/core/models/students/put_student_public/put_student_public.dart';
import 'package:attandance_simple/core/models/students/student_import_public/student_import_public.dart';
import 'package:equatable/equatable.dart';

abstract class StudentImportState extends Equatable {
  const StudentImportState();
  @override
  List<Object?> get props => [];
}

class StudentImportInitial extends StudentImportState {}

class StudentLoading extends StudentImportState {}

/// ketika list siswa berhasil di-load
class StudentListLoaded extends StudentImportState {
  final GetStudentPublic result; // berisi success, message, data (list)
  const StudentListLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

/// ketika berhasil import excel / bulk
class StudentImportSuccess extends StudentImportState {
  final StudentImportPublic result;
  const StudentImportSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

/// ketika berhasil tambah siswa
class StudentAddSuccess extends StudentImportState {
  final PostStudentPublic result;
  const StudentAddSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

/// ketika berhasil update siswa
class StudentUpdateSuccess extends StudentImportState {
  final PutStudentPublic result;
  const StudentUpdateSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

/// ketika berhasil delete siswa
class StudentDeleteSuccess extends StudentImportState {
  final DeletedStudentPublic result;
  const StudentDeleteSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class StudentError extends StudentImportState {
  final String message;
  const StudentError(this.message);

  @override
  List<Object?> get props => [message];
}
