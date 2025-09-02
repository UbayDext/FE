import 'dart:io';
import 'package:attandance_simple/core/cubit/cubit_sertifikat/sertifikat_state.dart';
import 'package:attandance_simple/core/models/sertifikat/get_by_students_public/datum.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikations_get_public/datum.dart';
import 'package:attandance_simple/core/utils/url_utils.dart';
import 'package:attandance_simple/core/presentation/view/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attandance_simple/core/cubit/cubit_sertifikat/sertifikat_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_student/student_import_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_student/student_import_state.dart';
import 'package:attandance_simple/core/models/sertifikat/sertifikat_get/datum.dart';
import 'package:intl/intl.dart';

class StudentSertifikatScreen extends StatefulWidget {
  final int studentId;
  final int? studiId;
  final int? classroomId;

  const StudentSertifikatScreen({
    super.key,
    required this.studentId,
    this.studiId,
    this.classroomId,
  });

  @override
  State<StudentSertifikatScreen> createState() =>
      _StudentSertifikatScreenState();
}

class _StudentSertifikatScreenState extends State<StudentSertifikatScreen> {
  final picker = ImagePicker();

  ({String name, String kelas, String ekskul}) _getStudentInfoFromCubit(
    BuildContext ctx,
  ) {
    final st = ctx.watch<StudentImportCubit>().state;
    if (st is StudentListLoaded) {
      final list = st.result.data ?? []; // ambil data list dari GetStudentNew
      final s = list.firstWhere(
        (e) => e.id == widget.studentId,
        orElse: () => list.isNotEmpty ? list.first : null!,
      );

      if (s != null) {
        return (
          name: s.name ?? '-',
          kelas: s.classroom?.name ?? '-',
          ekskul: s.ekskul?.namaEkskul ?? '-',
        );
      }
    }

    return (name: '-', kelas: '-', ekskul: '-');
  }

  void _openFileInline(String? raw) {
    if (raw == null || raw.isEmpty) return;
    final url = toAbsoluteUrl(raw);

    if (isPdfUrl(url)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PdfWebViewPage(url: url)),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: InteractiveViewer(
            child: Image.network(
              url,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                final v = progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                    : null;
                return SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator(value: v)),
                );
              },
              errorBuilder: (_, __, ___) => const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Gagal memuat gambar'),
              ),
            ),
          ),
        ),
      );
    }
  }

  void _showAddSertifikatDialog() {
    File? pickedFile;
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<SertifikatCubit>(),
        child: StatefulBuilder(
          builder: (context, setDialog) {
            return AlertDialog(
              title: const Text("Tambah Sertifikat"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Nama Lomba / Judul",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final x = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (x != null) setDialog(() => pickedFile = File(x.path));
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text(
                            pickedFile?.path.split('/').last ??
                                'Pilih gambar/pdf',
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 85),
                          Icon(Icons.upload),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                BlocConsumer<SertifikatCubit, SertifikatState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error!)));
                    } else if (!state.loading && state.lastAction == 'create') {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pop(context, true);
                      if (state.successMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.successMessage!)),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    final saving =
                        state.loading && state.lastAction == 'create';
                    return TextButton(
                      onPressed: saving
                          ? null
                          : () {
                              if (titleController.text.isEmpty ||
                                  pickedFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Judul & File wajib diisi'),
                                  ),
                                );
                                return;
                              }
                              context.read<SertifikatCubit>().create(
                                title: titleController.text,
                                studentId: widget.studentId,
                                file: pickedFile!,
                                studiId: widget.studiId!,
                                classroomId: widget.classroomId!,
                              );
                            },
                      child: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Save"),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<SertifikatCubit>(),
        child: AlertDialog(
          title: const Text('Hapus Sertifikat'),
          content: const Text('Yakin ingin menghapus?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            BlocConsumer<SertifikatCubit, SertifikatState>(
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error!)));
                } else if (!state.loading && state.lastAction == 'delete') {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.pop(context, true);
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.successMessage!)),
                    );
                  }
                }
              },
              builder: (context, state) {
                final deleting = state.loading && state.lastAction == 'delete';
                return TextButton(
                  onPressed: deleting
                      ? null
                      : () => context.read<SertifikatCubit>().remove(
                          id: id,
                          studentId: widget.studentId,
                        ),
                  child: deleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Hapus'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _getStudentInfoFromCubit(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.name),
            const SizedBox(height: 4),
            Text(
              'Kelas: ${info.kelas} • Ekskul: ${info.ekskul}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSertifikatDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: BlocBuilder<SertifikatCubit, SertifikatState>(
          builder: (context, state) {
            if (state.loading && state.lastAction == 'fetch') {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.list.isEmpty) {
              return Center(child: Text('❌ ${state.error}'));
            }
            final list = state.list;
            if (list.isEmpty) {
              return const Center(child: Text('Belum ada sertifikat'));
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final Datum d = list[i];
                final displayUrl = toAbsoluteUrl(d.fileUrl ?? d.filePath ?? '');
                final dt = d.createdAt;
                final dateStr = dt != null
                    ? DateFormat('yyyy-MM-dd').format(dt.toLocal())
                    : '-';
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.verified),
                    title: Text(d.title ?? '-'),
                    subtitle: Text(dateStr),
                    onTap: () => _openFileInline(displayUrl),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        if (d.id != null) _confirmDelete(d.id!);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
