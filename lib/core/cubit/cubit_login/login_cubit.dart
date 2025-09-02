import 'package:attandance_simple/core/cubit/cubit_login/login_state.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:attandance_simple/core/service/login_service.dart';
import 'package:bloc/bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  Future<void> toLogin(String email, String password) async {
  emit(state.copyWith(isLoading: true));

  var result = await LoginService().login(email: email, password: password);

  result.fold(
    (left) {
      emit(state.copyWith(error: left, isLoading: false));
    },
    (right) {
      emit(state.copyWith(loginResponse: right, isLoading: false));
      final token = right.token;
      if (token != null && token.isNotEmpty) {
        LocalStorage().saveToken(token);
        print('✅ TOKEN DISIMPAN: $token');
      } else {
        print('❌ TOKEN NULL / KOSONG');
      }
      final user = right.user;
      if (user != null) {
        LocalStorage().saveUser(user);
        print('✅ USER DISIMPAN: ${user.name}');
      } else {
        print('❌ USER NULL');
      }
    },
  );
}

}