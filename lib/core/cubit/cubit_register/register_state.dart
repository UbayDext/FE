// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attandance_simple/core/models/register_public/register_public.dart';
import 'package:equatable/equatable.dart';



class RegisterState extends Equatable {
  const RegisterState({
    this.registerRespone = const RegisterPublic(),
    this.Error = '',
    this.isLoading = false,
  });
  final RegisterPublic registerRespone;
  final bool isLoading;
  final String Error;

  @override
  List<Object?> get props => [registerRespone, isLoading, Error];

 

  RegisterState copyWith({
    RegisterPublic? registerRespone,
    bool? isLoading,
    String? Error,
  }) {
    return RegisterState(
      registerRespone: registerRespone ?? this.registerRespone,
      isLoading: isLoading ?? this.isLoading,
      Error: Error ?? this.Error,
    );
  }
}
