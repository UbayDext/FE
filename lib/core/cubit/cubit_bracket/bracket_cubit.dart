import 'package:attandance_simple/core/cubit/cubit_bracket/bracket_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attandance_simple/core/service/bracket_service.dart';

class BracketCubit extends Cubit<BracketState> {
  final BracketService _service;

  BracketCubit(this._service) : super(BracketInitial());

  Future<void> getTeam(int id) async {
    emit(BracketLoading());
    try {
      final data = await _service.getTeam(id);
      emit(BracketLoaded(data));
    } catch (e) {
      emit(BracketError(e.toString()));
    }
  }

  Future<void> setWinnerMatch1(int id, String winner) async {
    emit(BracketLoading());
    try {
      final result = await _service.setWinnerMatch1(
        teamRaceId: id,
        winner: winner,
      );
      emit(Match1Updated(result));
    } catch (e) {
      emit(BracketError(e.toString()));
    }
  }

  Future<void> setWinnerMatch2(int id, String winner) async {
    emit(BracketLoading());
    try {
      final result = await _service.setWinnerMatch2(
        TeamRaceId: id,
        winner: winner,
      );
      emit(Match2Updated(result));
    } catch (e) {
      emit(BracketError(e.toString()));
    }
  }

  Future<void> setChampion(int id, String champion) async {
    emit(BracketLoading());
    try {
      final result = await _service.setChampion(
        teamRaceId: id,
        champion: champion,
      );
      emit(ChampionUpdated(result));
    } catch (e) {
      emit(BracketError(e.toString()));
    }
  }
}
