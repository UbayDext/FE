import 'package:attandance_simple/core/models/studi_public/studi_public.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:dio/dio.dart';

class StudiService {
  Future<List<StudiPublic>> getAllStudi() async {
    final token = await LocalStorage().getToken();
    final dio = Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    final res = await dio.get('https://server.192.my.id/api/studi');
    if (res.data is List) {
      final List<dynamic> data = res.data as List;
      return data.map((e) => StudiPublic.fromMap(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Format respons API Studi tidak sesuai, diharapkan List');
    }
  }
}
