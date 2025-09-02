import 'package:attandance_simple/core/models/teamRace/deleted_team_public.dart';
import 'package:attandance_simple/core/models/teamRace/get_all_team_public/get_all_team_public.dart';
import 'package:attandance_simple/core/models/teamRace/post_team_public/post_team_public.dart';
import 'package:equatable/equatable.dart';

abstract class TeamInputState extends Equatable {
  const TeamInputState();

  @override
  List<Object?> get props => [];
}

/// State awal
class TeamInputInitial extends TeamInputState {}

/// Loading state
class TeamInputLoading extends TeamInputState {}

/// State sukses ambil semua team
class TeamInputLoaded extends TeamInputState {
  final GetAllTeamPublic teams;
  const TeamInputLoaded(this.teams);

  @override
  List<Object?> get props => [teams];
}

/// State sukses tambah team
class TeamInputAdded extends TeamInputState {
  final PostTeamPublic team;
  const TeamInputAdded(this.team);

  @override
  List<Object?> get props => [team];
}

/// State sukses update team
class TeamInputUpdated extends TeamInputState {
  final PostTeamPublic team;
  const TeamInputUpdated(this.team);

  @override
  List<Object?> get props => [team];
}

/// State sukses set champion
class TeamInputChampionSet extends TeamInputState {
  final PostTeamPublic team;
  const TeamInputChampionSet(this.team);

  @override
  List<Object?> get props => [team];
}

/// State sukses delete team
class TeamInputDeleted extends TeamInputState {
  final DeletedTeamPublic deleted;
  const TeamInputDeleted(this.deleted);

  @override
  List<Object?> get props => [deleted];
}

/// State error
class TeamInputError extends TeamInputState {
  final String message;
  const TeamInputError(this.message);

  @override
  List<Object?> get props => [message];
}
