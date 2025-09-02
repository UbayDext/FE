import 'package:attandance_simple/core/models/bracket/get_bracket_public/get_bracket_public.dart';
import 'package:attandance_simple/core/models/bracket/put_champion_public/put_champion_public.dart';
import 'package:attandance_simple/core/models/bracket/set_match1_public/set_match1_public.dart';
import 'package:attandance_simple/core/models/bracket/set_match2_public/set_match2_public.dart';
import 'package:attandance_simple/local_storange/Local_storange.dart';
import 'package:dio/dio.dart';

class BracketService {
  late Dio _dio;

  BracketService() {
    _dio = Dio(BaseOptions(baseUrl: 'https://server.192.my.id/api'));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (option, handler) async {
          String? token = await LocalStorage().getToken();
          if (token != null && token.isNotEmpty) {
            option.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(option);
        },
      ),
    );
  }

  Future<GetBracketPublic> getTeam(int id) async {
    try {
      final response = await _dio.get('/team-race/$id');
      return GetBracketPublic.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// POST: set winner match1
  Future<SetMatch1Public> setWinnerMatch1({
    required int teamRaceId,
    required String winner,
  }) async {
    try {
      final response = await _dio.post(
        '/team-races/$teamRaceId/set-winner-match1',
        data: {"winner_match1": winner},
      );

      return SetMatch1Public.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(
        'Gagal set winner match1: ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<SetMatch2Public> setWinnerMatch2({
    required int TeamRaceId,
    required String winner,
  }) async {
    try {
      final response = await _dio.post(
        '/team-races/$TeamRaceId/set-winner-match2',
        data: {"winner_match2": winner},
      );
      return SetMatch2Public.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(
        'Gagal set Winner match2: ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<PutChampionPublic> setChampion({
    required int teamRaceId,
    required String champion,
  }) async {
    try {
      final response = await _dio.put(
        '/team-races/$teamRaceId/set-champion',
        data: {"champion": champion},
      );

      return PutChampionPublic.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception('Gagal set champion: ${e.response?.data ?? e.message}');
    }
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
