

import 'package:attandance_simple/core/models/sertifikat/get_by_students_public/datum.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikations_get_public/datum.dart';
import 'package:equatable/equatable.dart';

class SertifikatState extends Equatable {
  final bool loading;
  final List<Datum> list;
  final String? error;
  final String? successMessage;
  final String? lastAction;

  const SertifikatState({
    this.loading = false,
    this.list = const [],
    this.error,
    this.successMessage,
    this.lastAction,
  });

  SertifikatState copyWith({
    bool? loading,
    List<Datum>? list,
    String? error,
    String? successMessage,
    String? lastAction,
  }) {
    return SertifikatState(
      loading: loading ?? this.loading,
      list: list ?? this.list,
      error: error,
      successMessage: successMessage,
      lastAction: lastAction ?? this.lastAction,
    );
  }

  @override
  List<Object?> get props => [loading, list, error, successMessage, lastAction];
}
