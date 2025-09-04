
import 'package:attandance_simple/core/models/attandance-ekskul/rekap_public.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';

class RekapService {
  final Dio _dio;
  static const String baseUrl = 'https://server.192.my.id';
  static const String _rekapPath = '/api/ekskul-attendance/rekap'; // GET

  RekapService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              headers: {'Accept': 'application/json'},
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (opts, handler) async {
          final token = await LocalStorage().getToken();
          if (token != null && token.isNotEmpty) {
            opts.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(opts);
        },
      ),
    );
  }

  /// GET /api/ekskul-attendance/rekap?ekskul_id=&tanggal=&studi_id=&classroom_id=
  Future<RekapPublic> getDailyRekap({
    required int ekskulId,
    required DateTime tanggal,
    int? studiId,
    int? classroomId,
  }) async {
    final ymd = DateFormat('yyyy-MM-dd').format(tanggal);
    final res = await _dio.get(
      _rekapPath,
      queryParameters: {
        'ekskul_id': ekskulId,
        'tanggal': ymd,
        if (studiId != null) 'studi_id': studiId,
        if (classroomId != null) 'classroom_id': classroomId,
      },
    );

    if (res.data is Map<String, dynamic>) {
      return RekapPublic.fromMap(res.data as Map<String, dynamic>);
    }
    throw Exception('Unexpected rekap response: ${res.data}');
  }

  // Alias opsional biar aman kalau di Cubit memanggil fetchRekap
  Future<RekapPublic> fetchRekap({
    required int ekskulId,
    required DateTime tanggal,
    int? studiId,
    int? classroomId,
  }) => getDailyRekap(
    ekskulId: ekskulId,
    tanggal: tanggal,
    studiId: studiId,
    classroomId: classroomId,
  );
}
