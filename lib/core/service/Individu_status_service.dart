import 'package:attandance_simple/core/models/individu/deleted_individu_public.dart';
import 'package:attandance_simple/core/models/individu/get_individu_public/get_individu_public.dart';
import 'package:attandance_simple/core/models/individu/post_individu_public/post_individu_public.dart';
import 'package:attandance_simple/core/models/individu/put_individu_public/put_individu_public.dart';
import 'package:dio/dio.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';

class IndividuStatusService {
  late final Dio _dio;

  IndividuStatusService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://server.192.my.id/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // GET dengan filter lombad_id
  Future<GetIndividuPublic> getIndividuLomba({required int lombadId}) async {
    try {
      final res = await _dio.get('/individurace', queryParameters: {
        'lombad_id': lombadId,
      });
      if (res.data is Map<String, dynamic>) {
        return GetIndividuPublic.fromMap(res.data as Map<String, dynamic>);
      }
      throw Exception('Format API GET tidak sesuai (harus Map JSON)');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // POST (create) — kirim lombad_id
  Future<PostIndividuPublic> createIndividuLomba({
    required String nameLomba,
    required int ekskulId,
    required String startDate, // yyyy-MM-dd
    required String endDate,   // yyyy-MM-dd
    required String status,    // 'berlangsung'|'selesai' (akan dinormalisasi di BE)
    required int lombadId,
  }) async {
    try {
      final res = await _dio.post('/individurace', data: {
        'name_lomba': nameLomba,
        'ekskul_id': ekskulId,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
        'lombad_id': lombadId,
      });
      if (res.data is Map<String, dynamic>) {
        return PostIndividuPublic.fromMap(res.data as Map<String, dynamic>);
      } else if (res.data is String) {
        return PostIndividuPublic.fromJson(res.data as String);
      }
      throw Exception('Format API POST tidak sesuai');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // PUT (update)
  Future<PutIndividuPublic> updateIndividuLomba({
    required int id,
    required String nameLomba,
    required int ekskulId,
    required String startDate,
    required String endDate,
    required String status,
  }) async {
    try {
      final res = await _dio.put('/individurace/$id', data: {
        'name_lomba': nameLomba,
        'ekskul_id': ekskulId,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
      });
      if (res.data is Map<String, dynamic>) {
        return PutIndividuPublic.fromMap(res.data as Map<String, dynamic>);
      } else if (res.data is String) {
        return PutIndividuPublic.fromJson(res.data as String);
      }
      throw Exception('Format API PUT tidak sesuai');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // DELETE
  Future<DeletedIndividuPublic> deletedIndividuLomba(int id) async {
    try {
      final res = await _dio.delete('/individurace/$id');
      if (res.data is Map<String, dynamic>) {
        return DeletedIndividuPublic.fromMap(res.data as Map<String, dynamic>);
      } else if (res.data is String) {
        return DeletedIndividuPublic.fromJson(res.data as String);
      }
      throw Exception('Format API DELETE tidak sesuai');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map) {
      final map = e.response!.data as Map;
      final msg = map['message']?.toString();
      if (map['errors'] is Map) {
        final errs = (map['errors'] as Map)
            .values
            .expand((v) => v is List ? v : [v])
            .join(' ');
        return [msg, errs]
            .where((s) => s != null && s.toString().isNotEmpty)
            .join(' ');
      }
      if (msg != null) return msg;
    }
    return e.message ?? 'Terjadi kesalahan jaringan';
  }
}
