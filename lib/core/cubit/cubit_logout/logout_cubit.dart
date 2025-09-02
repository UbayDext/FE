import 'package:attandance_simple/core/cubit/cubit_logout/logout_state.dart';
import 'package:attandance_simple/core/service/Logout_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutState());

  Future<void> logout(String token) async {
    emit(state.copyWith(isLogout: true, error: '', isSucces: false));
    final result = await LogoutService().logout(token);

    result.fold(
      (errorMessage) {
        print("Error cek lagi");
        emit(state.copyWith(isLogout: false, error: errorMessage));
        print('State Emitted: ${state.toString()}');
      },
      (succesMessage) {
        print('Log-out Succes');
        emit(state.copyWith(isLogout: true, isSucces: true));
        print('STATE EMITTED: ${state.toString()}');
      },
    );
  }
}
