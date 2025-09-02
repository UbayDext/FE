
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attandance_simple/core/service/Sertifikation_service.dart';

class SertifikatCountState {
  final Map<int, int> counts;
  final bool loading;
  final String? error;
  const SertifikatCountState({
    this.counts = const {},
    this.loading = false,
    this.error,
  });
  SertifikatCountState copyWith({Map<int,int>? counts, bool? loading, String? error}) =>
      SertifikatCountState(counts: counts ?? this.counts, loading: loading ?? this.loading, error: error);
}

class SertifikatCountCubit extends Cubit<SertifikatCountState> {
  final SertifikationService service;
  SertifikatCountCubit(this.service) : super(const SertifikatCountState());

  Future<void> fetchCounts({int? studiId, int? classroomId, int? ekskulId}) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final map = await service.getCounts(
        studiId: studiId,
        classroomId: classroomId,
        ekskulId: ekskulId,
      );
      emit(SertifikatCountState(counts: map, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
