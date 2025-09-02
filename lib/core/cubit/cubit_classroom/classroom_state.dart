import 'package:attandance_simple/core/models/classroom/classroom_get_public/classroom_get_public.dart';
import 'package:equatable/equatable.dart';


abstract class ClassroomState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClassroomInitial extends ClassroomState {}

class ClassroomLoading extends ClassroomState {}

class ClassroomLoaded extends ClassroomState {
  final List<ClassroomGetPublic> list;
  ClassroomLoaded(this.list);

  @override
  List<Object?> get props => [list];
}

class ClassroomError extends ClassroomState {
  final String msg;
  ClassroomError(this.msg);

  @override
  List<Object?> get props => [msg];
}
