import 'package:attandance_simple/core/models/forgot_password_public.dart';
import 'package:attandance_simple/core/models/reset_password_public.dart';
import 'package:attandance_simple/core/models/show_me_public/data.dart';
import 'package:attandance_simple/core/models/show_me_public/show_me_public.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  static const String _baseUrl = 'https://server.192.my.id';

  AuthService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
            ),
          );

  /// panggil ini setelah login / load token dari Hive/Prefs
  void setAuthToken(String? token) {
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<ForgotPasswordPublic> forgotPassword(String email) async {
    try {
      final res = await _dio.post(
        '/api/forgot-password',
        data: {'email': email},
      );
      return ForgotPasswordPublic.fromMap(Map<String, dynamic>.from(res.data));
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<ResetPasswordPublic> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final res = await _dio.post(
        '/api/reset-password',
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return ResetPasswordPublic.fromMap(Map<String, dynamic>.from(res.data));
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// GET /api/me/basic -> ShowMe (success, message, data)
  Future<ShowMePublic> getMeRaw() async {
    try {
      final res = await _dio.get('/api/me/basic');
      return ShowMePublic.fromMap(Map<String, dynamic>.from(res.data as Map));
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// Convenience: langsung ambil object Data (username, email, role)
  Future<Data> getMe() async {
    final me = await getMeRaw();
    if (me.data == null) {
      throw Exception(me.message ?? 'Data user tidak tersedia');
    }
    return me.data!;
  }

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
