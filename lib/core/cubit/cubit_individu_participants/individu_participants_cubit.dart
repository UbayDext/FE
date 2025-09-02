import 'package:flutter_bloc/flutter_bloc.dart';
import 'individu_participants_state.dart';
import 'package:attandance_simple/core/service/Individu_race_service.dart';

import 'package:attandance_simple/core/models/raceIndividu/get_candidat_public/get_candidat_public.dart';
import 'package:attandance_simple/core/models/raceIndividu/get_confirm_candidat/get_confirm_candidat.dart';
import 'package:attandance_simple/core/models/raceIndividu/add_candidat.dart';
import 'package:attandance_simple/core/models/raceIndividu/put_point/put_point.dart';
import 'package:attandance_simple/core/models/raceIndividu/deleted_candidat.dart';

import 'package:attandance_simple/core/models/raceIndividu/get_candidat_public/datum.dart'
    as cand;
import 'package:attandance_simple/core/models/raceIndividu/get_confirm_candidat/datum.dart'
    as art;

class IndividuParticipantsCubit extends Cubit<IndividuParticipantsState> {
  final IndividuParticipantsService service;

  IndividuParticipantsCubit(this.service)
      : super(const IndividuParticipantsState());

  /// GET candidates
  Future<void> fetchCandidates({required int raceId}) async {
    emit(state.copyWith(candidatesStatus: DataStatus.loading));
    try {
      final GetCandidatPublic res = await service.getCandidates(raceId: raceId);
      if (res.success == true && res.data != null) {
        emit(state.copyWith(
          candidatesStatus: DataStatus.success,
          candidates: res.data!, // ✅ List<cand.Datum>
        ));
      } else {
        throw Exception(res.message ?? 'Gagal memuat kandidat.');
      }
    } catch (e) {
      emit(state.copyWith(
        candidatesStatus: DataStatus.failure,
        candidatesError: e.toString(),
      ));
    }
  }

  /// GET participants
  Future<void> fetchParticipants({required int raceId}) async {
    emit(state.copyWith(participantsStatus: DataStatus.loading));
    try {
      final GetConfirmCandidat res = await service.getParticipants(raceId: raceId);
      if (res.success == true && res.data != null) {
        emit(state.copyWith(
          participantsStatus: DataStatus.success,
          participants: res.data!, // ✅ List<art.Datum>
        ));
      } else {
        throw Exception(res.message ?? 'Gagal memuat peserta.');
      }
    } catch (e) {
      emit(state.copyWith(
        participantsStatus: DataStatus.failure,
        participantsError: e.toString(),
      ));
    }
  }

  /// Tambah peserta
  Future<void> addParticipants({
    required int raceId,
    required List<int> studentIds,
  }) async {
    emit(state.copyWith(actionStatus: ActionStatus.loading, clearAction: true));
    try {
      final AddCandidat res =
          await service.addParticipants(raceId: raceId, studentIds: studentIds);

      if (res.success == true) {
        emit(state.copyWith(
          actionStatus: ActionStatus.success,
          actionMessage: res.message ?? 'Peserta ditambahkan',
        ));
        await fetchCandidates(raceId: raceId);
        await fetchParticipants(raceId: raceId);
      } else {
        throw Exception(res.message ?? 'Gagal menambah peserta');
      }
    } catch (e) {
      emit(state.copyWith(
        actionStatus: ActionStatus.failure,
        actionError: e.toString(),
      ));
    }
  }

  /// Update nilai 1 peserta
  Future<void> updateParticipantPoints({
    required int raceId,
    required int participantId,
    int? point1,
    int? point2,
    int? point3,
    int? point4,
    int? point5,
    bool refetchAfter = true,
  }) async {
    emit(state.copyWith(actionStatus: ActionStatus.loading, clearAction: true));
    try {
      final PutPoint res = await service.updateParticipantPoints(
        raceId: raceId,
        participantId: participantId,
        point1: point1,
        point2: point2,
        point3: point3,
        point4: point4,
        point5: point5,
      );

      if (res.success == true) {
        final idx = state.participants.indexWhere((p) => p.id == participantId);
        if (idx != -1) {
          final current = state.participants[idx];
          final updated = current.copyWith(
            point1: point1 ?? current.point1,
            point2: point2 ?? current.point2,
            point3: point3 ?? current.point3,
            point4: point4 ?? current.point4,
            point5: point5 ?? current.point5,
            total: res.data?.total ?? current.total,
          );
          final newList = List<art.Datum>.from(state.participants);
          newList[idx] = updated;
          emit(state.copyWith(participants: newList));
        }

        emit(state.copyWith(
          actionStatus: ActionStatus.success,
          actionMessage: res.message ?? 'Nilai diperbarui',
        ));

        if (refetchAfter) await fetchParticipants(raceId: raceId);
      } else {
        throw Exception(res.message ?? 'Gagal update nilai');
      }
    } catch (e) {
      emit(state.copyWith(
        actionStatus: ActionStatus.failure,
        actionError: e.toString(),
      ));
    }
  }

  /// Hapus peserta
  Future<void> deleteParticipant({
    required int raceId,
    required int participantId,
  }) async {
    emit(state.copyWith(actionStatus: ActionStatus.loading, clearAction: true));
    try {
      final DeletedCandidat res =
          await service.deleteParticipant(raceId: raceId, participantId: participantId);

      if (res.success == true) {
        final newList =
            state.participants.where((p) => p.id != participantId).toList();
        emit(state.copyWith(participants: newList));

        emit(state.copyWith(
          actionStatus: ActionStatus.success,
          actionMessage: res.message ?? 'Peserta dihapus',
        ));

        await fetchCandidates(raceId: raceId);
      } else {
        throw Exception(res.message ?? 'Gagal menghapus peserta');
      }
    } catch (e) {
      emit(state.copyWith(
        actionStatus: ActionStatus.failure,
        actionError: e.toString(),
      ));
    }
  }

  void clearAction() => emit(state.copyWith(clearAction: true));
}
