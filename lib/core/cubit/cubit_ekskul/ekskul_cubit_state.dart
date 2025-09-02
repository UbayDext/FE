
import 'package:attandance_simple/core/models/ekskul/ekskul_get/ekskul_get.dart';
import 'package:equatable/equatable.dart';


abstract class EkskulCubitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EkskulInitial extends EkskulCubitState {}

class EkskulLoading extends EkskulCubitState {}

class EkskulLoaded extends EkskulCubitState {
  final List<EkskulGet> list;
  EkskulLoaded(this.list);

  @override
  List<Object?> get props => [list];
}

class EkskulError extends EkskulCubitState {
  final String msg;
  EkskulError(this.msg);

  @override
  List<Object?> get props => [msg];
}
