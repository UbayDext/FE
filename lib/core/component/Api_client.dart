import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://server.192.my.id/api',
            headers: {'Accept': 'application/json'},
            connectTimeout: const Duration(seconds: 25),
            receiveTimeout: const Duration(seconds: 25),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await LocalStorage().getToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
          ),
        )
        ..interceptors.add(
          LogInterceptor(requestBody: true, responseBody: true),
        );

  static Dio get dio => _dio;

  // Opsional: panggil ini setelah login sukses
  static void setAuthHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
