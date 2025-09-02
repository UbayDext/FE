import 'package:attandance_simple/core/service/Auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_state.dart';



class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthService service;
  ForgotPasswordCubit(this.service) : super(const ForgotPasswordState());

  Future<void> sendToken(String email) async {
    emit(state.copyWith(loading: true, clearError: true, clearData: true));
    try {
      final res = await service.forgotPassword(email);
      emit(state.copyWith(loading: false, data: res));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}

