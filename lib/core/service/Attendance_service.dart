import 'package:attandance_simple/core/models/attandance-ekskul/update_status_public.dart';
import 'package:dio/dio.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:attandance_simple/core/models/attandance-ekskul/get_siswa_public/get_siswa_public.dart';

class AttendanceService {
  final Dio _dio;

  static const String _base = 'https://server.192.my.id/api/';

  // ⛏️ SESUAIKAN DENGAN ROUTE BE
  static const String _dailyPath  = 'ekskul-attendance/daily';
  static const String _upsertPath = 'ekskul-attendance/update';

  AttendanceService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _base,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 20),
                headers: {'Accept': 'application/json'},
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Log lengkap biar kelihatan URL-nya
          // (hapus kalau sudah stabil)
          // ignore: avoid_print
          print('[DIO] ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (res, handler) {
          // ignore: avoid_print
          print('[DIO] <${res.statusCode}> ${res.requestOptions.uri}');
          handler.next(res);
        },
        onError: (e, handler) {
          // ignore: avoid_print
          print('[DIO][ERR] <${e.response?.statusCode}> ${e.requestOptions.uri}');
          handler.next(e);
        },
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // GET /api/ekskul-attendance/daily
  Future<List<GetSiswaPublic>> fetchDailyAll({
    required int ekskulId,
    required DateTime date,
    int? studiId,
    int? classroomId,
  }) async {
    final res = await _dio.get(
      _dailyPath, // ← fix
      queryParameters: <String, dynamic>{
        'ekskul_id': ekskulId,
        'tanggal': _fmt(date),
        if (studiId != null) 'studi_id': studiId,
        if (classroomId != null) 'classroom_id': classroomId,
      },
    );

    // Terima {data:[...]} atau langsung [...]
    final data = res.data;
    final List list =
        (data is Map && data['data'] is List) ? data['data'] : (data as List);

    return list
        .map((e) => GetSiswaPublic.fromMap(
              Map<String, dynamic>.from(e as Map),
            ))
        .toList();
  }

  // POST /api/ekskul-attendance/update
  Future<UpdateStatusPublic> upsertStatus({
    required int studentId,
    required int ekskulId,
    required DateTime date,
    required String status, // 'H'|'I'|'S'|'A'
    required int studiId,
  }) async {
    final res = await _dio.post(
      _upsertPath, // ← fix
      data: <String, dynamic>{
        'student_id': studentId,
        'ekskul_id': ekskulId,
        'tanggal': _fmt(date),
        'status': status,
        'studi_id': studiId,
      },
    );
    return UpdateStatusPublic.fromMap((res.data as Map).cast<String, dynamic>());
  }

  Future<void> upsertBulk(
    List<
        ({int studentId, int ekskulId, DateTime date, String status, int studiId})>
        items,
  ) async {
    for (final it in items) {
      await upsertStatus(
        studentId: it.studentId,
        ekskulId: it.ekskulId,
        date: it.date,
        status: it.status,
        studiId: it.studiId,
      );
    }
  }
}
