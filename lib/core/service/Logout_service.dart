import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

class LogoutService {
  Future<Either<String, String>> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://server.192.my.id/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Right('Logout Berhasil');
      } else {
        return Left('Logout gagal: ${response.body}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
