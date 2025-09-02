import 'package:attandance_simple/core/cubit/cubit_input_team/input_team_state.dart';
import 'package:attandance_simple/core/service/Team_service_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamInputCubit extends Cubit<TeamInputState> {
  final TeamInputService service;

  TeamInputCubit(this.service) : super(TeamInputInitial());

  /// Ambil semua team berdasarkan lombadId
  Future<void> getTeams(int lombadId) async {
    emit(TeamInputLoading());
    try {
      final teams = await service.getTeams(lombadId);
      emit(TeamInputLoaded(teams));
    } catch (e) {
      emit(TeamInputError(e.toString()));
    }
  }

  /// Tambah team
  Future<void> addTeam({
    required String nameGroup,
    required String nameTeam1,
    required String nameTeam2,
    required String nameTeam3,
    required String nameTeam4,
    required int lombadId,
  }) async {
    emit(TeamInputLoading());
    try {
      await service.addTeam(
        nameGroup: nameGroup,
        nameTeam1: nameTeam1,
        nameTeam2: nameTeam2,
        nameTeam3: nameTeam3,
        nameTeam4: nameTeam4,
        lombadId: lombadId,
      );
      // langsung refresh list
      final teams = await service.getTeams(lombadId);
      emit(TeamInputLoaded(teams));
    } catch (e) {
      emit(TeamInputError(e.toString()));
    }
  }

  /// Update team
  Future<void> updateTeam(int id, Map<String, dynamic> payload) async {
    emit(TeamInputLoading());
    try {
      final team = await service.updateTeam(id, payload);
      emit(TeamInputUpdated(team));
    } catch (e) {
      emit(TeamInputError(e.toString()));
    }
  }

  /// Set Champion
  Future<void> setChampion(int id, String champion) async {
    emit(TeamInputLoading());
    try {
      final team = await service.setChampion(id, champion);
      emit(TeamInputChampionSet(team));
    } catch (e) {
      emit(TeamInputError(e.toString()));
    }
  }

  /// Delete team
  Future<void> deleteTeam(int id, {required int lombadId}) async {
  emit(TeamInputLoading());
  try {
    await service.deleteTeam(id);
    final teams = await service.getTeams(lombadId); // refresh list
    emit(TeamInputLoaded(teams));
  } catch (e) {
    emit(TeamInputError(e.toString()));
  }
}

}
