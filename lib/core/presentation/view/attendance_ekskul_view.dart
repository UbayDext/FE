import 'package:attandance_simple/core/component/appbar_ekskul.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/cubit/cubit_attendance_ekskul/attendance_ekskul_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_attendance_ekskul/attendance_ekskul_state.dart';

class AttendanceEkskulView extends StatelessWidget {
  const AttendanceEkskulView({super.key});

  String getFormattedDate(DateTime d) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarEkskul(),
      body: BlocBuilder<AttendanceEkskulCubit, AttendanceEkskulState>(
        builder: (context, state) {
          final cubit = context.read<AttendanceEkskulCubit>();
          final selectedDate = cubit.selectedDate;
          final namaEkskul = cubit.namaEkskul;

          if (state.loading)
            return const Center(child: CircularProgressIndicator());
          if (state.error != null)
            return Center(child: Text('❌ ${state.error}'));

          final rekap = cubit.getRekapStatus();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text(
                      namaEkskul,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      getFormattedDate(selectedDate),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: Colors.grey[200],
                child: const Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        'No',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Nama Siswa',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'H',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'I',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'S',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'A',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.grey),

              Expanded(
                child: state.daftar.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada siswa yang terdaftar di ekskul ini.',
                        ),
                      )
                    : ListView.separated(
                        itemCount: state.daftar.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final row = state.daftar[index]; // GetSiswaPublic
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text('${index + 1}'),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    row.name ?? '-',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Radio<String>(
                                    value: 'H',
                                    groupValue: row.status,
                                    onChanged: (v) => v != null
                                        ? context
                                              .read<AttendanceEkskulCubit>()
                                              .updateStatus(row.studentId!, v)
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Radio<String>(
                                    value: 'I',
                                    groupValue: row.status,
                                    onChanged: (v) => v != null
                                        ? context
                                              .read<AttendanceEkskulCubit>()
                                              .updateStatus(row.studentId!, v)
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Radio<String>(
                                    value: 'S',
                                    groupValue: row.status,
                                    onChanged: (v) => v != null
                                        ? context
                                              .read<AttendanceEkskulCubit>()
                                              .updateStatus(row.studentId!, v)
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Radio<String>(
                                    value: 'A',
                                    groupValue: row.status,
                                    onChanged: (v) => v != null
                                        ? context
                                              .read<AttendanceEkskulCubit>()
                                              .updateStatus(row.studentId!, v)
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: _RekapCard(
                  h: rekap['H']!,
                  i: rekap['I']!,
                  s: rekap['S']!,
                  a: rekap['A']!,
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => _confirmSave(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Save All'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmSave(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Konfirmasi Simpan'),
        content: const Text(
          'Apakah data sudah benar? Data tidak bisa di-update/dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('Cek Kembali'),
          ),
          TextButton(
            onPressed: () async {
              final cubit = context.read<AttendanceEkskulCubit>();
              final ok = await cubit.simpanDataAbsensiEkskul();
              Navigator.pop(dialog);
              if (ok && context.mounted) Navigator.pop(context, true);
            },
            child: const Text('YA, SIMPAN'),
          ),
        ],
      ),
    );
  }
}

class _RekapCard extends StatelessWidget {
  final int h, i, s, a;
  const _RekapCard({
    required this.h,
    required this.i,
    required this.s,
    required this.a,
  });

  Widget _item(String label, int value, Color color) {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.grey[50],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item('Hadir', h, Colors.green),
            _item('Izin', i, Colors.blue),
            _item('Sakit', s, Colors.orange),
            _item('Alpa', a, Colors.red),
          ],
        ),
      ),
    );
  }
}
