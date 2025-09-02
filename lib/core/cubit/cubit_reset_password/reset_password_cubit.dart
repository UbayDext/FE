import 'package:attandance_simple/core/models/reset_password_public.dart';
import 'package:attandance_simple/core/service/Auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthService service;

  ResetPasswordCubit(this.service) : super(ResetPasswordInitial());

  Future<void> submitReset({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    debugPrint("✅ CUBIT: Metode submitReset dimulai.");
    emit(ResetPasswordLoading());
    debugPrint("✅ CUBIT: State ResetPasswordLoading telah di-emit.");

    try {
      if (password != passwordConfirmation) {
        throw Exception('Password dan konfirmasi password tidak cocok');
      }
      if (password.length < 6) {
        throw Exception('Password minimal harus 6 karakter');
      }

      final ResetPasswordPublic result = await service.resetPassword(
        email: email,
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      debugPrint(
        "✅ CUBIT: Panggilan service berhasil. Response: ${result.toMap()}",
      );

      if (result.success == true) {
        emit(
          ResetPasswordSuccess(result.message ?? 'Password berhasil direset!'),
        );
        debugPrint("✅ CUBIT: State ResetPasswordSuccess telah di-emit.");
      } else {
        throw Exception(result.message ?? 'Gagal mereset password.');
      }
    } catch (e) {
      debugPrint("❌ CUBIT ERROR: ${e.toString()}");
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}
