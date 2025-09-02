
import 'package:attandance_simple/core/models/register_public/register_public.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class RegisterService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  Future<Either<String, RegisterPublic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        'https://server.192.my.id/api/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );
      final registerData = RegisterPublic.fromMap(response.data);
      return Right(registerData);
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'Ukhnown error';
        return Left('Error: [$statusCode]: $message');
      } else {
        return Left('Connection error: ${e.message}');
      }
    }
  }
}
