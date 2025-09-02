import 'package:attandance_simple/core/models/ekskul/ekskul_get/ekskul_get.dart';
import 'package:attandance_simple/core/models/lomba/get_lomba_pub/datum.dart';
import 'package:equatable/equatable.dart';

// ✅ Tambahkan kembali enum status
enum LombaStatus { initial, loading, success, failure }
enum LombaActionStatus { initial, loading, success, failure }

class LombaState extends Equatable {
  final LombaStatus status;
  final List<Datum> lombaList;
  final String? error;
  final LombaActionStatus actionStatus;
  final String? successMessage;
  final String? actionError;
  final List<EkskulGet> availableEkskuls; // ✅ pakai EkskulGet

  const LombaState({
    this.status = LombaStatus.initial,
    this.lombaList = const [],
    this.error,
    this.actionStatus = LombaActionStatus.initial,
    this.successMessage,
    this.actionError,
    this.availableEkskuls = const [],
  });

  LombaState copyWith({
    LombaStatus? status,
    List<Datum>? lombaList,
    String? error,
    LombaActionStatus? actionStatus,
    String? successMessage,
    String? actionError,
    List<EkskulGet>? availableEkskuls,
    bool clearActionState = false,
  }) {
    return LombaState(
      status: status ?? this.status,
      lombaList: lombaList ?? this.lombaList,
      error: error ?? this.error,
      actionStatus: clearActionState
          ? LombaActionStatus.initial
          : (actionStatus ?? this.actionStatus),
      successMessage:
          clearActionState ? null : (successMessage ?? this.successMessage),
      actionError: clearActionState ? null : (actionError ?? this.actionError),
      availableEkskuls: availableEkskuls ?? this.availableEkskuls,
    );
  }

  @override
  List<Object?> get props => [
        status,
        lombaList,
        error,
        actionStatus,
        successMessage,
        actionError,
        availableEkskuls,
      ];
}
