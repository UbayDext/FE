import 'dart:io';
import 'package:attandance_simple/core/component/Api_client.dart';
import 'package:attandance_simple/core/models/students/add_manny_public.dart';
import 'package:attandance_simple/core/models/students/deleted_student_public.dart';
import 'package:attandance_simple/core/models/students/get_student_public/get_student_public.dart';
import 'package:attandance_simple/core/models/students/post_student_public/post_student_public.dart';
import 'package:attandance_simple/core/models/students/put_student_public/put_student_public.dart';
import 'package:attandance_simple/core/models/students/student_import_public/student_import_public.dart';
import 'package:dio/dio.dart';

class StudentService {
  final Dio _dio = ApiClient.dio;

  /// Import siswa lewat file Excel/CSV
  Future<StudentImportPublic> importStudent(
    File file, {
    List<int>? bytes,
    String? filename,
    int? studiId,
  }) async {
    final formData = FormData();

    if (bytes != null) {
      formData.files.add(
        MapEntry(
          'file',
          MultipartFile.fromBytes(bytes, filename: filename ?? 'import.xlsx'),
        ),
      );
    } else {
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(
            file.path,
            filename: file.uri.pathSegments.last,
          ),
        ),
      );
    }

    if (studiId != null) {
      formData.fields.add(MapEntry('studi_id', '$studiId'));
    }

    final res = await _dio.post('/students/import', data: formData);
    return StudentImportPublic.fromMap(res.data);
  }

  /// GET daftar siswa (dengan filter classroom, ekskul, studi)
  Future<GetStudentPublic> getStudents({
    int? classId,
    int? ekskulId,
    int? studiId,
    String? search,
  }) async {
    final res = await _dio.get(
      '/students',
      queryParameters: {
        if (classId != null) 'classroom_id': classId,
        if (ekskulId != null) 'ekskul_id': ekskulId,
        if (studiId != null) 'studi_id': studiId,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    return GetStudentPublic.fromMap(res.data);
  }

  /// POST tambah siswa baru
  Future<PostStudentPublic> addStudent(Map<String, dynamic> data) async {
    final res = await _dio.post('/students', data: data);
    return PostStudentPublic.fromMap(res.data);
  }

  /// PUT update data siswa
  Future<PutStudentPublic> updateStudent(
    int id,
    Map<String, dynamic> data,
  ) async {
    final res = await _dio.put('/students/$id', data: data);
    return PutStudentPublic.fromMap(res.data);
  }

  /// DELETE hapus siswa
  Future<DeletedStudentPublic> deleteStudent(int id) async {
    final res = await _dio.delete('/students/$id');
    return DeletedStudentPublic.fromMap(res.data);
  }

  /// POST import banyak siswa dari JSON
  Future<StudentImportPublic> addManyStudents(
    List<Map<String, dynamic>> dataList,
  ) async {
    final res = await _dio.post(
      '/students/import_many',
      data: {'students': dataList},
    );
    return StudentImportPublic.fromMap(res.data);
  }
}
