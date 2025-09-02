import 'package:attandance_simple/core/cubit/cubit_lomba/lomba_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_lomba/lomba_state.dart';
import 'package:attandance_simple/core/models/lomba/get_lomba_pub/datum.dart'; // Model Lomba
import 'package:attandance_simple/core/models/ekskul/ekskul_get/ekskul_get.dart'; // ✅ gunakan EkskulGet

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LombaFormDialog extends StatefulWidget {
  final Datum? lomba; // kalau edit, data lomba dimasukkan
  const LombaFormDialog({this.lomba, super.key});

  @override
  State<LombaFormDialog> createState() => LombaFormDialogState();
}

class LombaFormDialogState extends State<LombaFormDialog> {
  // Controller dan state lokal
  late final TextEditingController _namaController;
  late String? _currentStatus;
  late int? _currentEkskulId;

  @override
  void initState() {
    super.initState();
    // Inisialisasi form kalau mode edit
    _namaController = TextEditingController(text: widget.lomba?.name ?? '');
    _currentStatus = widget.lomba?.status;
    _currentEkskulId = widget.lomba?.ekskulId;
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LombaCubit, LombaState>(
      builder: (context, state) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            widget.lomba == null ? 'Tambah Data Lomba' : 'Edit Data Lomba',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Input Nama Lomba
                TextFormField(
                  controller: _namaController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Nama Lomba',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Dropdown Status
                DropdownButtonFormField<String>(
                  value: _currentStatus,
                  hint: const Text('Pilih Status Lomba'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Individu', 'Team']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _currentStatus = v),
                ),
                const SizedBox(height: 16),

                // Dropdown Ekskul
                DropdownButtonFormField<int>(
                  value: _currentEkskulId,
                  hint: const Text('Pilih Ekskul'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: state.availableEkskuls.map<DropdownMenuItem<int>>((
                    EkskulGet ekskul,
                  ) {
                    return DropdownMenuItem<int>(
                      value: ekskul.id,
                      child: Text(ekskul.namaEkskul ?? 'Tanpa Nama'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _currentEkskulId = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(widget.lomba == null ? 'Simpan' : 'Update'),
              onPressed: () {
                if (_namaController.text.isNotEmpty &&
                    _currentStatus != null &&
                    _currentEkskulId != null) {
                  if (widget.lomba == null) {
                    // Mode tambah lomba
                    context.read<LombaCubit>().addLomba(
                      name: _namaController.text,
                      status: _currentStatus!,
                      ekskulId: _currentEkskulId!,
                    );
                  } else {
                    // Mode edit lomba
                    context.read<LombaCubit>().editLomba(
                      id: widget.lomba!.id!,
                      name: _namaController.text,
                      status: _currentStatus!,
                      ekskulId: _currentEkskulId!,
                    );
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua field harus diisi'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
