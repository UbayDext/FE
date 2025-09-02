import 'package:attandance_simple/core/cubit/cubit_rekap/rekap_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_rekap/rekap_state.dart';
import 'package:attandance_simple/core/presentation/screen/attendance_ekskul_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateEkskulView extends StatelessWidget {
  final String namaEkskul;
  final String infoEkskul;

  const DateEkskulView({
    super.key,
    required this.namaEkskul,
    required this.infoEkskul,
  });

  String _fmt(DateTime d) => DateFormat('d MMMM y', 'id_ID').format(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nama Logo')),
      body: BlocBuilder<RekapCubit, RekapState>(
        builder: (context, state) {
          final cubit = context.read<RekapCubit>();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  'Jadwal Kehadiran untuk:',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  namaEkskul,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CalendarDatePicker(
                    initialDate: state.selectedDate,
                    firstDate: DateTime(2020, 1, 1),
                    lastDate: DateTime(2100, 12, 31),
                    onDateChanged: cubit.setDate,
                  ),
                ),

                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: Colors.grey[50],
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _fmt(state.selectedDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _rekapItem('Hadir', state.h, Colors.green),
                            _rekapItem('Izin', state.i, Colors.blue),
                            _rekapItem('Sakit', state.s, Colors.orange),
                            _rekapItem('Alpa', state.a, Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.playlist_add_check),
                    label: const Text('Lihat Kehadiran Ekskul'),
                    onPressed: () async {
                      final rekapCubit = context.read<RekapCubit>();
                      final currentState =
                          rekapCubit.state; 
                      final bool? saveSuccess = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttendanceEkskulScreen(
                            namaEkskul: namaEkskul,
                            selectedDate: currentState.selectedDate,
                            ekskulId: rekapCubit
                                .ekskulId, 
                            classroomId: rekapCubit
                                .classroomId, 
                            studiId: rekapCubit
                                .studiId, 
                          ),
                        ),
                      );
                      if (saveSuccess == true && context.mounted) {
                     
                        rekapCubit.fetch();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _rekapItem(String label, int value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
