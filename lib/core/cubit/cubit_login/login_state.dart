// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:attandance_simple/core/models/login_public/login_public.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    this.loginResponse = const LoginPublic(),
    this.isLoading = false,
    this.error = '',
  });
    final LoginPublic loginResponse;
    final bool isLoading;
    final String error;
  @override
  List<Object> get props => [loginResponse, isLoading, error];

  LoginState copyWith({
    LoginPublic? loginResponse,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      loginResponse: loginResponse ?? this.loginResponse,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

