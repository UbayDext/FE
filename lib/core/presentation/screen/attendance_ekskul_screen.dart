// lib/core/screen/attendance_ekskul_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attandance_simple/core/cubit/cubit_attendance_ekskul/attendance_ekskul_cubit.dart';
import 'package:attandance_simple/core/service/attendance_service.dart';
import 'package:attandance_simple/core/presentation/view/attendance_ekskul_view.dart';

class AttendanceEkskulScreen extends StatelessWidget {
  final String namaEkskul;
  final DateTime selectedDate;
  final int ekskulId;
  final int? classroomId;
  final int? studiId;

  const AttendanceEkskulScreen({
    super.key,
    required this.namaEkskul,
    required this.selectedDate,
    required this.ekskulId,
    this.classroomId,
    this.studiId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceEkskulCubit(
        service: AttendanceService(),
        ekskulId: ekskulId,
        selectedDate: selectedDate,
        namaEkskul: namaEkskul,
        classroomId: classroomId,
        studiId: studiId,
      )..fetchDaily(), // <= WAJIB: langsung ambil dari BE
      child: const AttendanceEkskulView(),
    );
  }
}
