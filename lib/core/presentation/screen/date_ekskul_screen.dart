import 'package:attandance_simple/core/cubit/cubit_rekap/rekap_cubit.dart';
import 'package:attandance_simple/core/service/rekap_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attandance_simple/core/presentation/view/Date_ekskul_view.dart';

class DateEkskulScreen extends StatelessWidget {
  final String namaEkskul;
  final String infoEkskul;

  // filter
  final int ekskulId;
  final int studiId;
  final int classroomId; // 0/null = lintas kelas

  const DateEkskulScreen({
    super.key,
    required this.namaEkskul,
    required this.infoEkskul,
    required this.ekskulId,
    required this.studiId,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    final classroomParam = (classroomId == 0) ? null : classroomId;

    return BlocProvider(
      create: (_) => RekapCubit(
        service: RekapService(),
        ekskulId: ekskulId,
        studiId: studiId,
        classroomId: classroomParam,
        initialDate: DateTime.now(),
      )..fetch(),
      child: DateEkskulView(
        namaEkskul: namaEkskul,
        infoEkskul: infoEkskul,
      ),
    );
  }
}
