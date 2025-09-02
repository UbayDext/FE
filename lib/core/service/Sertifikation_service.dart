import 'dart:io';

import 'package:attandance_simple/core/models/sertifikat/get_by_students_public/get_by_students_public.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikations_get_public/sertifikations_get_public.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikat_deleted.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikat_get/sertifikat_get.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikat_put/sertifikat_put.dart'
    as put_wrap;
import 'package:attandance_simple/core/models/sertifikat/post_sertifikation_public/post_sertifikation_public.dart'
    as post_wrap;
import 'package:dio/dio.dart';

class SertifikationService {
  final Dio _dio;
  static const String baseUrl = 'https://server.192.my.id';
  static const String apiPath = '/api/sertifikations';

  SertifikationService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 20),
              headers: {'Accept': 'application/json'},
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await LocalStorage().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<SertifikationsGetPublic> getByStudent({
    required int studentId,
    int? studiId,
    int? ekskulId,
    int? classroomId,
  }) async {
    final res = await _dio.get(
      apiPath,
      queryParameters: {
        'student_id': studentId,
        if (studiId != null) 'studi_id': studiId,
        if (ekskulId != null) 'ekskul_id': ekskulId,
        if (classroomId != null) 'classroom_id': classroomId,
      },
    );
    return SertifikationsGetPublic.fromMap(res.data as Map<String, dynamic>);
  }

  Future<post_wrap.PostSertifikationPublic> create({
    required String title,
    required int studentId,
    int? studiId,
    int? ekskulId,
    int? classroomId,
    required File file,
  }) async {
    final fd = FormData.fromMap({
      'title': title,
      'student_id': studentId,
      if (studiId != null) 'studi_id': studiId,
      if (ekskulId != null) 'ekskul_id': ekskulId,
      if (classroomId != null) 'classroom_id': classroomId,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });
    final res = await _dio.post(apiPath, data: fd);
    return post_wrap.PostSertifikationPublic.fromMap(
      res.data as Map<String, dynamic>,
    );
  }

  Future<put_wrap.SertifikatPut> update({
    required int id,
    String? title,
    int? studentId,
    int? studiId,
    int? ekskulId,
    int? classroomId,
    File? file,
  }) async {
    final map = <String, dynamic>{
      if (title != null) 'title': title,
      if (studentId != null) 'student_id': studentId,
      if (studiId != null) 'studi_id': studiId,
      if (ekskulId != null) 'ekskul_id': ekskulId,
      if (classroomId != null) 'classroom_id': classroomId,
    };
    final fd = FormData.fromMap({
      ...map,
      if (file != null)
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
    });
    // method override (jika BE tidak menerima PUT multipart langsung)
    final res = await _dio.post(
      '$apiPath/$id',
      data: fd,
      options: Options(
        method: 'POST',
        headers: {'X-HTTP-Method-Override': 'PUT'},
      ),
    );

    return put_wrap.SertifikatPut.fromMap(res.data as Map<String, dynamic>);
  }

  Future<SertifikatDeleted> delete(int id) async {
    final res = await _dio.delete('$apiPath/$id');
    return SertifikatDeleted.fromMap(res.data as Map<String, dynamic>);
  }

  Future<Map<int, int>> getCounts({
    int? studiId,
    int? classroomId,
    int? ekskulId,
    String? from,
    String? to,
  }) async {
    final res = await _dio.get(
      '/api/sertifikations-counts', // atau '/api/sertifikations/counts' -> samakan dengan route
      queryParameters: {
        if (studiId != null) 'studi_id': studiId,
        if (classroomId != null) 'classroom_id': classroomId,
        if (ekskulId != null) 'ekskul_id': ekskulId,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      },
    );

    final data = res.data['data'];
    final map = <int, int>{};

    if (data is List) {
      for (final row in data) {
        final sid = int.tryParse(row['student_id'].toString());
        final tot = int.tryParse(row['total'].toString());
        if (sid != null) map[sid] = tot ?? 0;
      }
    } else if (data is Map) {
      // jaga-jaga kalau BE balikannya map keyed-strings
      data.forEach((k, v) {
        final sid = int.tryParse(k.toString());
        final tot = int.tryParse(v.toString());
        if (sid != null) map[sid] = tot ?? 0;
      });
    }
    // debug:
    // print('COUNT MAP => $map');
    return map;
  }
}
