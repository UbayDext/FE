import 'package:attandance_simple/core/cubit/cubit_register/register_state.dart';
import 'package:attandance_simple/core/service/Register_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  Future<void> toRegister(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    emit(
      state.copyWith(isLoading: true),
    );

    final watch = await RegisterService().register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    watch.fold(
      (left) {
        emit(state.copyWith(Error: left, isLoading: false));
      },

      (right) {
        print('RESPONSE REGISTER: ${right.toJson()}');
        emit(state.copyWith(registerRespone: right, isLoading: false));
      },
    );
  }
}