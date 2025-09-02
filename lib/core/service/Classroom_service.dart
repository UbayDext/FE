import 'package:attandance_simple/core/models/classroom/classroom_get_public/classroom_get_public.dart';
import 'package:attandance_simple/core/models/classroom/deleted_classroom_public.dart';
import 'package:attandance_simple/core/models/classroom/post_classroom_public.dart';
import 'package:attandance_simple/core/models/classroom/put_classroom_public.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ClassroomService {
  late Dio _dio;

  ClassroomService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://server.192.my.id/api',
    ));

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

 Future<List<ClassroomGetPublic>> fetchClassrooms({int? studiId}) async {
    try {
      final res = await _dio.get(
        '/classrooms',
        queryParameters: studiId != null ? {'studi_id': studiId} : null,
      );

      // BE: { success, message, data: [...] }
      final body = Map<String, dynamic>.from(res.data as Map);
      final list = (body['data'] as List)
          .map((e) => ClassroomGetPublic.fromMap(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
      return list;
    } on DioException catch (e) {
      // bantu debugging jika beda dengan Postman
      debugPrint('[GET] ${e.requestOptions.uri}');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Body  : ${e.response?.data}');
      rethrow;
    }
  }

  Future<PostClassroomPublic> createClassroom(PostClassroomPublic data) async {
    final response = await _dio.post('/classrooms', data: data.toMap());
    return PostClassroomPublic.fromMap(response.data);
  }

  Future<PutClassroomPublic> updateClassroom(int id, PutClassroomPublic data) async {
    final response = await _dio.put('/classrooms/$id', data: data.toMap());
    return PutClassroomPublic.fromMap(response.data);
  }

  Future<DeletedClassroomPublic> deleteClassroom(int id) async {
    final response = await _dio.delete('/classrooms/$id');
    return DeletedClassroomPublic.fromMap(response.data);
  }
}
