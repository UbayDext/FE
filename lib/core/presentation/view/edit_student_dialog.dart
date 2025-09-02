import 'package:attandance_simple/core/cubit/cubit_student/student_import_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditStudentDialog extends StatefulWidget {
  final int id;
  final String initialName;
  final String initialClass;
  final String initialEkskul;
  final int studiId;

  const EditStudentDialog({
    super.key,
    required this.id,
    required this.initialName,
    required this.initialClass,
    required this.initialEkskul,
    required this.studiId,
  });

  @override
  State<EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController classCtrl;
  late final TextEditingController ekskulCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initialName);
    classCtrl = TextEditingController(text: widget.initialClass);
    ekskulCtrl = TextEditingController(text: widget.initialEkskul);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    classCtrl.dispose();
    ekskulCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (nameCtrl.text.trim().isEmpty ||
        classCtrl.text.trim().isEmpty ||
        ekskulCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama, Kelas, dan Ekskul wajib diisi')),
      );
      return;
    }

    context.read<StudentImportCubit>().updateStudent(widget.id, {
      'name': nameCtrl.text.trim(),
      'classroom_name': classCtrl.text.trim(),
      'ekskul_name': ekskulCtrl.text.trim(),
    });

    Navigator.of(context, rootNavigator: true).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Data Siswa'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama Siswa'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: classCtrl,
              decoration: const InputDecoration(labelText: 'Kelas'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: ekskulCtrl,
              decoration: const InputDecoration(labelText: 'Ekskul'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}
