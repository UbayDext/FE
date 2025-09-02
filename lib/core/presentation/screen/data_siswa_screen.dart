import 'dart:io';
import 'package:attandance_simple/core/cubit/cubit_sertifikat/sertifikat_count_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_sertifikat/sertifikat_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_student/student_import_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_student/student_import_state.dart';
import 'package:attandance_simple/core/presentation/screen/student_sertifikation_screen.dart';
import 'package:attandance_simple/core/service/Sertifikation_service.dart';
import 'package:attandance_simple/core/service/Students_service.dart';
import 'package:attandance_simple/core/presentation/view/add_many_students_dialog.dart';
import 'package:attandance_simple/core/presentation/view/edit_student_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataSiswaScreen extends StatefulWidget {
  final int studiId;
  final int classroomId;
  final String infoStudi;
  final String infoClass;
  final List<String> kelasList;
  final List<String> ekskulList;

  const DataSiswaScreen({
    super.key,
    required this.studiId,
    required this.classroomId,
    required this.infoStudi,
    required this.infoClass,
    required this.kelasList,
    required this.ekskulList,
  });

  @override
  State<DataSiswaScreen> createState() => _DataSiswaScreenState();
}

class _DataSiswaScreenState extends State<DataSiswaScreen> {
  late final StudentImportCubit _studentsCubit;

  @override
  void initState() {
    super.initState();
    _studentsCubit = StudentImportCubit(StudentService());
    _studentsCubit.fetchStudents(
      classId: widget.classroomId,
      studiId: widget.studiId,
    );
  }

  @override
  void dispose() {
    _studentsCubit.close();
    super.dispose();
  }

  Future<void> _importExcel() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
      withData: true,
    );
    if (res == null) return;

    final picked = res.files.single;
    if (picked.path != null) {
      await _studentsCubit.importStudents(File(picked.path!));
    } else if (picked.bytes != null) {
      await _studentsCubit.importStudentsFromBytes(
        picked.bytes!,
        filename: picked.name,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membaca file (path & bytes null)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _studentsCubit),
        BlocProvider(
          create: (_) =>
              SertifikatCountCubit(SertifikationService())..fetchCounts(
                studiId: widget.studiId,
                classroomId: widget.classroomId,
                // ekskulId: bisa diisi kalau mau batasi per ekskul
              ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jenjang ${widget.infoStudi}'),
              const SizedBox(height: 4),
              Text(
                'Kelas ${widget.infoClass}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        body: BlocListener<StudentImportCubit, StudentImportState>(
          listener: (context, state) async {
            if (state is StudentError) {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }

            // ✅ Tambah siswa sukses
            if (state is StudentAddSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.result.message ?? 'Tambah siswa berhasil',
                  ),
                ),
              );
              _studentsCubit.fetchStudents(
                classId: widget.classroomId,
                studiId: widget.studiId,
              );
            }

            // ✅ Update siswa sukses
            if (state is StudentUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.result.message ?? 'Update siswa berhasil',
                  ),
                ),
              );
              _studentsCubit.fetchStudents(
                classId: widget.classroomId,
                studiId: widget.studiId,
              );
            }

            // ✅ Delete siswa sukses
            if (state is StudentDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.result.message ?? 'Siswa berhasil dihapus',
                  ),
                ),
              );
              _studentsCubit.fetchStudents(
                classId: widget.classroomId,
                studiId: widget.studiId,
              );
            }

            // ✅ Import sukses (excel / many)
            if (state is StudentImportSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.result.message ?? 'Import berhasil'),
                ),
              );
              _studentsCubit.fetchStudents(
                classId: widget.classroomId,
                studiId: widget.studiId,
              );
            }
          },
          child: BlocBuilder<StudentImportCubit, StudentImportState>(
            builder: (context, state) {
              if (state is StudentLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is StudentListLoaded) {
                final students = state.result.data ?? [];
                if (students.isEmpty) {
                  return const Center(child: Text('Belum ada data siswa'));
                }

                final countMap = context.select(
                  (SertifikatCountCubit c) => c.state.counts,
                );

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: students.length,
                  itemBuilder: (context, i) {
                    final s = students[i];
                    final total = s.id == null ? 0 : (countMap[s.id!] ?? 0);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(s.name ?? '-'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kelas: ${s.classroom?.name ?? '-'}'),
                            Text('Ekskul: ${s.ekskul?.namaEkskul ?? '-'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () async {
                                if (s.id == null) return;
                                final refresh = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                          value: _studentsCubit,
                                        ),
                                        BlocProvider(
                                          create: (_) =>
                                              SertifikatCubit(
                                                SertifikationService(),
                                              )..fetch(
                                                studentId: s.id!,
                                                studiId: widget.studiId,
                                                classroomId: widget.classroomId,
                                              ),
                                        ),
                                      ],
                                      child: StudentSertifikatScreen(
                                        studentId: s.id!,
                                        studiId: widget.studiId,
                                        classroomId: widget.classroomId,
                                      ),
                                    ),
                                  ),
                                );
                                if (refresh == true && context.mounted) {
                                  context
                                      .read<SertifikatCountCubit>()
                                      .fetchCounts(
                                        studiId: widget.studiId,
                                        classroomId: widget.classroomId,
                                      );
                                }
                              },
                              child: Text(
                                'Sertifikat $total',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              onSelected: (v) {
                                if (v == 'edit') {
                                  showDialog(
                                    context: context,
                                    builder: (_) => BlocProvider.value(
                                      value: _studentsCubit,
                                      child: EditStudentDialog(
                                        id: s.id!,
                                        initialName: s.name ?? '',
                                        initialClass: s.classroom?.name ?? '',
                                        initialEkskul:
                                            s.ekskul?.namaEkskul ?? '',
                                        studiId: widget.studiId,
                                      ),
                                    ),
                                  );
                                } else if (v == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Hapus Data'),
                                      content: Text(
                                        'Yakin ingin menghapus ${s.name}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _studentsCubit.deleteStudent(s.id!);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'import',
              backgroundColor: Colors.orange,
              onPressed: _importExcel,
              child: const Icon(Icons.file_upload),
              tooltip: 'Import Excel/CSV',
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'add',
              backgroundColor: Colors.blue,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: _studentsCubit,
                    child: AddManyStudentsDialog(
                      studiId: widget.studiId,
                      classroomId: widget.classroomId,
                      kelasList: widget.kelasList,
                      ekskulList: widget.ekskulList,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
              tooltip: 'Tambah Bulk (Paste)',
            ),
          ],
        ),
      ),
    );
  }
}
