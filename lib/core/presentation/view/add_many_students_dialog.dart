import 'package:attandance_simple/core/cubit/cubit_student/student_import_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddManyStudentsDialog extends StatefulWidget {
  final int studiId;
  final int classroomId;
  final List<String> kelasList;
  final List<String> ekskulList;

  const AddManyStudentsDialog({
    super.key,
    required this.studiId,
    required this.classroomId,
    required this.kelasList,
    required this.ekskulList,
  });

  @override
  State<AddManyStudentsDialog> createState() => _AddManyStudentsDialogState();
}

class _AddManyStudentsDialogState extends State<AddManyStudentsDialog> {
  final textCtrl = TextEditingController();

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final lines = textCtrl.text.trim().split('\n');
    final payload = <Map<String, dynamic>>[];

    for (final line in lines) {
      final parts = line.split(RegExp(r'[,;\t]')).map((e) => e.trim()).toList();
      if (parts.length < 3) continue;
      payload.add({
        'name': parts[0],
        'classroom_name': parts[1],
        'ekskul_name': parts[2],
        'studi_id':
            widget.studiId, // opsional (backend juga bisa auto dari kelas)
      });
    }

    context.read<StudentImportCubit>().addManyStudents(
      payload,
      classId: widget.classroomId,
      studiId: widget.studiId,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Siswa (Paste)'),
      content: TextField(
        controller: textCtrl,
        maxLines: 8,
        decoration: const InputDecoration(
          labelText: 'Format: Nama, Kelas, Ekskul',
          hintText: 'Contoh:\nAhmad, 2A, Futsal\nBudi, 5E, Pramuka',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(onPressed: _submit, child: const Text('Kirim')),
      ],
    );
  }
}
