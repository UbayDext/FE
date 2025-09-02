// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:equatable/equatable.dart';

class LogoutState extends Equatable {
  final bool isLogout;
  final bool isSucces;
  final String error;
  const LogoutState({
    this.isLogout = false,
    this.isSucces = false,
    this.error = ''
  });
  

  @override
  List<Object> get props => [isLogout, isSucces, error];

  

  LogoutState copyWith({
    bool? isLogout,
    bool? isSucces,
    String? error,
  }) {
    return LogoutState(
      isLogout: isLogout ?? this.isLogout,
      isSucces: isSucces ?? this.isSucces,
      error: error ?? this.error,
    );
  }
}

final class LogoutInitial extends LogoutState {}
