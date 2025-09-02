import 'package:attandance_simple/core/models/bracket/get_bracket_public/get_bracket_public.dart';
import 'package:attandance_simple/core/models/bracket/put_champion_public/put_champion_public.dart';
import 'package:attandance_simple/core/models/bracket/set_match1_public/set_match1_public.dart';
import 'package:attandance_simple/core/models/bracket/set_match2_public/set_match2_public.dart';
import 'package:equatable/equatable.dart';

abstract class BracketState extends Equatable {
  const BracketState();

  @override
  List<Object?> get props => [];
}

class BracketInitial extends BracketState {}

class BracketLoading extends BracketState {}

class BracketLoaded extends BracketState {
  final GetBracketPublic bracket;
  const BracketLoaded(this.bracket);

  @override
  List<Object?> get props => [bracket];
}

class Match1Updated extends BracketState {
  final SetMatch1Public result;
  const Match1Updated(this.result);

  @override
  List<Object?> get props => [result];
}

class Match2Updated extends BracketState {
  final SetMatch2Public result;
  const Match2Updated(this.result);

  @override
  List<Object?> get props => [result];
}

class ChampionUpdated extends BracketState {
  final PutChampionPublic result;
  const ChampionUpdated(this.result);

  @override
  List<Object?> get props => [result];
}

class BracketError extends BracketState {
  final String message;
  const BracketError(this.message);

  @override
  List<Object?> get props => [message];
}
