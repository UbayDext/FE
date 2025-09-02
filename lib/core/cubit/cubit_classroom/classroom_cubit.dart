import 'package:attandance_simple/core/cubit/cubit_classroom/classroom_state.dart';
import 'package:attandance_simple/core/models/classroom/post_classroom_public.dart';
import 'package:attandance_simple/core/models/classroom/put_classroom_public.dart';
import 'package:attandance_simple/core/service/Classroom_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomCubit extends Cubit<ClassroomState> {
  final ClassroomService service;
  ClassroomCubit(this.service) : super(ClassroomInitial());

  Future<void> fetchClassrooms({int? studiId}) async {
    emit(ClassroomLoading());
    try {
      final data = await service.fetchClassrooms(studiId: studiId);
      emit(ClassroomLoaded(data));
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }

  Future<void> createClassroom(PostClassroomPublic data, {int? studiId}) async {
    emit(ClassroomLoading());
    try {
      await service.createClassroom(data);
      await fetchClassrooms(studiId: studiId);
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }

  Future<void> updateClassroom(
    int id,
    PutClassroomPublic data, {
    int? studiId,
  }) async {
    emit(ClassroomLoading());
    try {
      await service.updateClassroom(id, data);
      await fetchClassrooms(studiId: studiId);
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }

  Future<void> deleteClassroom(int id, {int? studiId}) async {
    emit(ClassroomLoading());
    try {
      await service.deleteClassroom(id);
      await fetchClassrooms(studiId: studiId);
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }
}
