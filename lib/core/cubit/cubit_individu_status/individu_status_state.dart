import 'package:attandance_simple/core/models/individu/get_individu_public/datum.dart';
import 'package:equatable/equatable.dart';


enum DataStatus { initial, loading, success, failure }
enum ActionStatus { idle, loading, success, failure }

class IndividuStatusState extends Equatable {
  final DataStatus status;
  final List<Datum> lombaList;
  final String? error;

  // aksi (POST/PUT/DELETE)
  final ActionStatus actionStatus;
  final String? successMessage;
  final String? actionError;

  const IndividuStatusState({
    this.status = DataStatus.initial,
    this.lombaList = const [],
    this.error,
    this.actionStatus = ActionStatus.idle,
    this.successMessage,
    this.actionError,
  });

  IndividuStatusState copyWith({
    DataStatus? status,
    List<Datum>? lombaList,
    String? error,
    ActionStatus? actionStatus,
    String? successMessage,
    String? actionError,
    bool clearActionState = false,
  }) {
    return IndividuStatusState(
      status: status ?? this.status,
      lombaList: lombaList ?? this.lombaList,
      error: error ?? this.error,
      actionStatus: clearActionState ? ActionStatus.idle : (actionStatus ?? this.actionStatus),
      successMessage: clearActionState ? null : (successMessage ?? this.successMessage),
      actionError: clearActionState ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props =>
      [status, lombaList, error, actionStatus, successMessage, actionError];
}
