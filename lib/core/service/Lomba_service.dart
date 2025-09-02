import 'package:attandance_simple/core/models/ekskul/ekskul_get/ekskul_get.dart';
import 'package:attandance_simple/core/models/lomba/get_lomba_pub/ekskul.dart';
import 'package:attandance_simple/core/models/lomba/get_lomba_pub/get_lomba_pub.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:attandance_simple/core/models/lomba/deletedlomba.dart';
import 'package:attandance_simple/core/models/lomba/postlomba.dart';
import 'package:attandance_simple/core/models/lomba/putlomba.dart';
import 'package:dio/dio.dart';

class LombaService {
  late Dio _dio;

  LombaService() {
    _dio = Dio(BaseOptions(baseUrl: 'https://server.192.my.id/api'));

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

Future<GetLombaPub> getAllLomba() async {
  try {
    final response = await _dio.get('/lombads');

    if (response.data is Map) {
      return GetLombaPub.fromMap(response.data as Map<String, dynamic>);
    } else {
      throw Exception("Format respons API tidak sesuai (harus Map)");
    }
  } on DioException catch (e) {
    throw Exception(_extractError(e));
  }
}



  Future<List<EkskulGet>> getAllEkskul() async {
  final res = await _dio.get('/ekskul');

  if (res.data is Map && res.data['data'] is List) {
    final List<dynamic> data = res.data['data'];
    return data.map((e) => EkskulGet.fromMap(e as Map<String, dynamic>)).toList();
  } else {
    throw Exception(
      "Format respons API Ekskul tidak sesuai, diharapkan Map dengan key 'data' yang berisi List",
    );
  }
}

  /// POST /lomba - Membuat data lomba baru
  Future<Postlomba> createLomba({
    required String name,
    required String status,
    required int ekskulId,
  }) async {
    try {
      final response = await _dio.post(
        '/lombads',
        data: {'name': name, 'status': status, 'ekskul_id': ekskulId},
      );
      return Postlomba.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// PUT /lomba/{id} - Memperbarui data lomba
  Future<Putlomba> updateLomba({
    required int id,
    required String name,
    required String status,
    required int ekskulId,
  }) async {
    try {
      final response = await _dio.put(
        '/lombads/$id',
        data: {'name': name, 'status': status, 'ekskul_id': ekskulId},
      );
      return Putlomba.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// DELETE /lomba/{id} - Menghapus data lomba
  Future<Deletedlomba> deleteLomba(int id) async {
    try {
      final response = await _dio.delete('/lombads/$id');
      return Deletedlomba.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // Helper untuk mengekstrak pesan error dari DioException
  String _extractError(DioException e) {
    if (e.response != null && e.response?.data is Map) {
      final data = e.response!.data as Map;
      final msg = data['message']?.toString();
      if (data['errors'] is Map) {
        final errs = (data['errors'] as Map).values
            .expand((v) => v is List ? v : [v])
            .join(' ');
        return [
          msg,
          errs,
        ].where((s) => s != null && s.toString().isNotEmpty).join(' ');
      }
      if (msg != null) return msg;
    }
    return e.message ?? 'Terjadi kesalahan jaringan';
  }
}
