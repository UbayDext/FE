import 'package:attandance_simple/core/models/teamRace/deleted_team_public.dart';
import 'package:attandance_simple/core/models/teamRace/get_all_team_public/get_all_team_public.dart';
import 'package:attandance_simple/core/models/teamRace/post_team_public/post_team_public.dart';

import 'package:dio/dio.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';

class TeamInputService {
  late Dio _dio;

  TeamInputService() {
    _dio = Dio(BaseOptions(baseUrl: 'https://server.192.my.id/api'));
    // Tambahkan interceptor supaya token otomatis di-attach
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await LocalStorage().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  /// GET semua team berdasarkan lombad_id
  Future<GetAllTeamPublic> getTeams(int lombadId) async {
    try {
      final response = await _dio.get('/lomba/$lombadId/team-race');
      return GetAllTeamPublic.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// POST tambah team baru
  Future<PostTeamPublic> addTeam({
    required String nameGroup,
    required String nameTeam1,
    required String nameTeam2,
    required String nameTeam3,
    required String nameTeam4,
    required int lombadId,
  }) async {
    try {
      final response = await _dio.post(
        '/team-races',
        data: {
          "name_group": nameGroup,
          "name_team1": nameTeam1,
          "name_team2": nameTeam2,
          "name_team3": nameTeam3,
          "name_team4": nameTeam4,
          "lombad_id": lombadId,
        },
      );
      return PostTeamPublic.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// PUT update team
  Future<PostTeamPublic> updateTeam(
    int id,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.put('/team-races/$id', data: payload);
      return PostTeamPublic.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// PUT set champion
  Future<PostTeamPublic> setChampion(int id, String champion) async {
    try {
      final response = await _dio.put(
        '/team-races/$id/set-champion',
        data: {"champion": champion},
      );
      return PostTeamPublic.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// DELETE team
  Future<DeletedTeamPublic> deleteTeam(int id) async {
    try {
      final response = await _dio.delete('/team-race/$id');
      return DeletedTeamPublic.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // Helper: ambil pesan error dari Dio
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
