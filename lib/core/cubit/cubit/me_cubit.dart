import 'package:attandance_simple/core/models/show_me_public/data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:attandance_simple/core/service/Auth_service.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';

part 'me_state.dart';

class MeCubit extends Cubit<MeState> {
  final AuthService auth;
  final LocalStorage storage;

  MeCubit({required this.auth, required this.storage}) : super(MeInitial());

  Future<void> load() async {
    emit(MeLoading());
    try {
      await storage.init();
      final token = await storage.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia');
      }
      auth.setAuthToken(token);
      final me = await auth.getMe(); // <- return Data (username, email, role)
      emit(MeLoaded(me));
    } catch (e) {
      emit(MeError(e.toString()));
    }
  }
}
