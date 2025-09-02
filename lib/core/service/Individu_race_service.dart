import 'package:attandance_simple/core/models/raceIndividu/add_candidat.dart';
import 'package:attandance_simple/core/models/raceIndividu/deleted_candidat.dart';
import 'package:attandance_simple/core/models/raceIndividu/get_candidat_public/get_candidat_public.dart';
import 'package:attandance_simple/core/models/raceIndividu/get_confirm_candidat/get_confirm_candidat.dart';
import 'package:attandance_simple/core/models/raceIndividu/post_point_public.dart';
import 'package:attandance_simple/core/models/raceIndividu/put_point/put_point.dart';
import 'package:dio/dio.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';

class IndividuParticipantsService {
  late final Dio _dio;

  IndividuParticipantsService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://server.192.my.id/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  /// GET /api/individurace/{raceId}/candidates
  Future<GetCandidatPublic> getCandidates({required int raceId}) async {
    try {
      final res = await _dio.get('/individurace/$raceId/candidates');
      if (res.data is Map<String, dynamic>) {
        return GetCandidatPublic.fromMap(res.data as Map<String, dynamic>);
      }
      throw Exception('Format API tidak sesuai (harus Map JSON).');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<AddCandidat> addParticipants({
    required int raceId,
    required List<int> studentIds,
  }) async {
    if (studentIds.isEmpty) {
      throw Exception('student_ids tidak boleh kosong');
    }

    try {
      final res = await _dio.post(
        '/individurace/$raceId/participants',
        data: {'student_ids': studentIds},
      );

      if (res.data is Map<String, dynamic>) {
        return AddCandidat.fromMap(res.data as Map<String, dynamic>);
      } else if (res.data is String) {
        return AddCandidat.fromJson(res.data as String);
      }
      throw Exception('Format API tidak sesuai (harus Map/String JSON).');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<GetConfirmCandidat> getParticipants({required int raceId}) async {
    try {
      final res = await _dio.get('/individurace/$raceId/participants');

      if (res.data is Map<String, dynamic>) {
        return GetConfirmCandidat.fromMap(res.data as Map<String, dynamic>);
      } else if (res.data is String) {
        return GetConfirmCandidat.fromJson(res.data as String);
      }
      throw Exception('Format API tidak sesuai (harus Map/String JSON).');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map) {
      final map = e.response!.data as Map;
      final msg = map['message']?.toString();
      if (map['errors'] is Map) {
        final errs = (map['errors'] as Map).values
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

  Future<PostPointPublic> bulkScores({
    required int raceId,
    required List<ScoreUpdate> scores,
  }) async {
    if (scores.isEmpty) {
      throw Exception('scores tidak boleh kosong');
    }

    try {
      final payload = {'scores': scores.map((e) => e.toMap()).toList()};

      final res = await _dio.post(
        '/individurace/$raceId/participants/bulk-scores',
        data: payload,
      );

      if (res.data is Map<String, dynamic>) {
        return PostPointPublic.fromMap(res.data as Map<String, dynamic>);
      } else if (res.data is String) {
        return PostPointPublic.fromJson(res.data as String);
      }
      throw Exception('Format API tidak sesuai (harus Map/String JSON).');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // PUT individurace/{race}/participants/{participant}
  Future<PutPoint> updateParticipantPoints({
    required int raceId,
    required int participantId,
    int? point1,
    int? point2,
    int? point3,
    int? point4,
    int? point5,
  }) async {
    // Kirim hanya field yang diubah
    final body = <String, dynamic>{};
    void put(String k, int? v) {
      if (v != null) body[k] = v;
    }

    put('point1', point1);
    put('point2', point2);
    put('point3', point3);
    put('point4', point4);
    put('point5', point5);

    if (body.isEmpty) throw Exception('Tidak ada nilai poin yang diubah');

    try {
      final res = await _dio.put(
        '/individurace/$raceId/participants/$participantId',
        data: body,
      );

      if (res.data is Map<String, dynamic>) {
        return PutPoint.fromMap(res.data as Map<String, dynamic>);
      } else if (res.data is String) {
        return PutPoint.fromJson(res.data as String);
      }
      throw Exception('Format API tidak sesuai (harus Map/String JSON).');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// DELETE /api/individurace/{raceId}/participants/{participantId}
  Future<DeletedCandidat> deleteParticipant({
    required int raceId,
    required int participantId,
  }) async {
    try {
      final res = await _dio.delete(
        '/individurace/$raceId/participants/$participantId',
      );

      if (res.data is Map<String, dynamic>) {
        return DeletedCandidat.fromMap(res.data as Map<String, dynamic>);
      } else if (res.data is String) {
        return DeletedCandidat.fromJson(res.data as String);
      }
      throw Exception('Format API tidak sesuai (harus Map/String JSON).');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

/// Helper untuk payload bulk-scores.
/// Isi hanya nilai yang ingin diubah; null tidak akan dikirim.
class ScoreUpdate {
  final int participantId;
  final int? point1;
  final int? point2;
  final int? point3;
  final int? point4;
  final int? point5;

  const ScoreUpdate({
    required this.participantId,
    this.point1,
    this.point2,
    this.point3,
    this.point4,
    this.point5,
  });

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{'participant_id': participantId};
    void put(String k, int? v) {
      if (v != null) m[k] = v;
    }

    put('point1', point1);
    put('point2', point2);
    put('point3', point3);
    put('point4', point4);
    put('point5', point5);
    return m;
  }
}
