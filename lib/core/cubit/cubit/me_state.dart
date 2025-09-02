part of 'me_cubit.dart';

abstract class MeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MeInitial extends MeState {}

class MeLoading extends MeState {}

class MeLoaded extends MeState {
  final Data me;
  MeLoaded(this.me);
  @override
  List<Object?> get props => [me];
}

class MeError extends MeState {
  final String message;
  MeError(this.message);
  @override
  List<Object?> get props => [message];
}
