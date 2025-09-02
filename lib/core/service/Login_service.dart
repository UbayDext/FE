import 'package:attandance_simple/core/models/login_fix/login_fix.dart';
import 'package:attandance_simple/core/models/login_public/login_public.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class LoginService {
  final acces = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<Either<String, LoginPublic>> login({
    required String email,
    required String password,
  }) async {
    try {
      var response = await acces.post(
        'https://server.192.my.id/api/login',
        data: {"email": email, "password": password},
      );

      var dataResponse = LoginPublic.fromMap(response.data);
      return Right(dataResponse);
    } on DioException catch (e) {
      if (e.response != null) {
        var statusCode = e.response?.statusCode;
        var message = e.response?.data['message'] ?? 'Unkhnow error';
        return Left('Error [$statusCode] : $message');
      } else {
        return Left('Conecction error: ${e.message}');
      }
    }
  }
}
