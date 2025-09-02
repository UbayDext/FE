import 'package:attandance_simple/core/models/forgot_password_public.dart';
import 'package:attandance_simple/core/service/Auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordState extends Equatable {
  final bool loading;
  final ForgotPasswordPublic? data;
  final String? error;

  const ForgotPasswordState({this.loading = false, this.data, this.error});

  ForgotPasswordState copyWith({
    bool? loading,
    ForgotPasswordPublic? data,
    String? error,
    bool clearError = false,
    bool clearData = false,
  }) {
    return ForgotPasswordState(
      loading: loading ?? this.loading,
      data: clearData ? null : (data ?? this.data),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [loading, data, error];
}
