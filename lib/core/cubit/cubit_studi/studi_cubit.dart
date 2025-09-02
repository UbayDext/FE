import 'package:attandance_simple/core/service/Studi_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'studi_state.dart';

class StudiCubit extends Cubit<StudiState> {
  StudiCubit() : super(const StudiState());

  Future<void> fetchStudi() async {
    emit(state.copyWith(isLoading: true));
    try {
      final studiList = await StudiService().getAllStudi();
      emit(state.copyWith(data: studiList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
