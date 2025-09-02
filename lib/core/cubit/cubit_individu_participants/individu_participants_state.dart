import 'package:equatable/equatable.dart';
import 'package:attandance_simple/core/models/raceIndividu/get_candidat_public/datum.dart'
    as cand;
import 'package:attandance_simple/core/models/raceIndividu/get_confirm_candidat/datum.dart'
    as art;

enum DataStatus { initial, loading, success, failure }
enum ActionStatus { initial, loading, success, failure }

class IndividuParticipantsState extends Equatable {
  final DataStatus candidatesStatus;
  final DataStatus participantsStatus;
  final ActionStatus actionStatus;

  final List<cand.Datum> candidates;
  final List<art.Datum> participants;

  final String? candidatesError;
  final String? participantsError;
  final String? actionMessage;
  final String? actionError;

  const IndividuParticipantsState({
    this.candidatesStatus = DataStatus.initial,
    this.participantsStatus = DataStatus.initial,
    this.actionStatus = ActionStatus.initial,
    this.candidates = const [],
    this.participants = const [],
    this.candidatesError,
    this.participantsError,
    this.actionMessage,
    this.actionError,
  });

  IndividuParticipantsState copyWith({
    DataStatus? candidatesStatus,
    DataStatus? participantsStatus,
    ActionStatus? actionStatus,
    List<cand.Datum>? candidates,
    List<art.Datum>? participants,
    String? candidatesError,
    String? participantsError,
    String? actionMessage,
    String? actionError,
    bool clearAction = false,
  }) {
    return IndividuParticipantsState(
      candidatesStatus: candidatesStatus ?? this.candidatesStatus,
      participantsStatus: participantsStatus ?? this.participantsStatus,
      actionStatus: clearAction ? ActionStatus.initial : (actionStatus ?? this.actionStatus),
      candidates: candidates ?? this.candidates,
      participants: participants ?? this.participants,
      candidatesError: candidatesError ?? this.candidatesError,
      participantsError: participantsError ?? this.participantsError,
      actionMessage: clearAction ? null : (actionMessage ?? this.actionMessage),
      actionError: clearAction ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props => [
        candidatesStatus,
        participantsStatus,
        actionStatus,
        candidates,
        participants,
        candidatesError,
        participantsError,
        actionMessage,
        actionError,
      ];
}
