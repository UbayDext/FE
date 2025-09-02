import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_deleted.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_get/ekskul_get.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_post.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_put.dart';
import 'package:dio/dio.dart';

class EkskulService {
  late Dio _dio;

  EkskulService() {
    _dio = Dio(BaseOptions(baseUrl: 'http://server.192.my.id/api'));

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

  Future<List<EkskulGet>> fetchEkskul({int? studiId}) async {
    final response = await _dio.get(
      '/ekskul',
      queryParameters: {if (studiId != null) 'studi_id': studiId},
    );

    // Pastikan response berupa Map dengan key "data"
    if (response.data is Map<String, dynamic> &&
        response.data['data'] is List) {
      final List<dynamic> list = response.data['data'];
      return list
          .map((e) => EkskulGet.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        "Format respons API Ekskul tidak sesuai. Diharapkan { success, message, data: [] }",
      );
    }
  }

  Future<EkskulPost> createEkskul(EkskulPost data) async {
    final respone = await _dio.post('/ekskul', data: data.toMap());
    return EkskulPost.fromMap(respone.data);
  }

  Future<EkskulPut> updateEkskul(int id, EkskulPut data) async {
    final response = await _dio.put('/ekskul/$id', data: data.toMap());
    return EkskulPut.fromMap(response.data);
  }

  Future<EkskulDeleted> deleteEkskul(int id) async {
    final response = await _dio.delete('/ekskul/$id');
    return EkskulDeleted.fromMap(response.data);
  }
}
