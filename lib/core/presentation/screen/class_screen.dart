import 'package:attandance_simple/core/cubit/cubit_classroom/classroom_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_classroom/classroom_state.dart';
import 'package:attandance_simple/core/models/classroom/classroom_get_public/classroom_get_public.dart';
import 'package:attandance_simple/core/models/classroom/post_classroom_public.dart';
import 'package:attandance_simple/core/models/classroom/put_classroom_public.dart';
import 'package:attandance_simple/core/presentation/screen/data_siswa_screen.dart';
import 'package:attandance_simple/core/service/Classroom_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassScreen extends StatelessWidget {
  final int studiId;
  final String infoStudi; // nama studi/jenjang, untuk tampilan
  final String classInfo;
  const ClassScreen({
    Key? key,
    required this.studiId,
    required this.infoStudi,
    required this.classInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ClassroomCubit(ClassroomService())..fetchClassrooms(studiId: studiId),
      child: Scaffold(
        appBar: AppBar(title: Text('Jenjang $infoStudi')),
        body: BlocBuilder<ClassroomCubit, ClassroomState>(
          builder: (context, state) {
            if (state is ClassroomLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ClassroomError) {
              return Center(child: Text('Error: ${state.msg}'));
            }
            if (state is ClassroomLoaded) {
              final kelasList = state.list;
              if (kelasList.isEmpty) {
                return const Center(
                  child: Text('Belum ada kelas di studi ini.'),
                );
              }
              return ListView.builder(
                itemCount: kelasList.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final kelas = kelasList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(kelas.name ?? '-'),
                      subtitle: Text(
                        'Jumlah siswa: ${kelas.studentsCount ?? 0}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditDialog(context, kelas);
                          } else if (value == 'delete') {
                            _showDeleteDialog(context, kelas.id!);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                      ),
                      onTap: () async {
                        
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DataSiswaScreen(
                              studiId: studiId,
                              classroomId: kelas.id!,
                              infoStudi: infoStudi,
                              infoClass: kelas.name ?? '-',
                              kelasList: const [],
                              ekskulList: const [],
                            ),
                          ),
                        );
                        if (context.mounted) {
                          context.read<ClassroomCubit>().fetchClassrooms(
                            studiId: studiId,
                          );
                        }
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Kelas'),
        content: TextFormField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nama Kelas'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            child: const Text('Simpan'),
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                final data = PostClassroomPublic(
                  name: nameCtrl.text,
                  studiId: studiId,
                );
                // pastikan createClassroom return Future
                await context.read<ClassroomCubit>().createClassroom(
                  data,
                  studiId: studiId,
                );
                if (context.mounted) {
                  context.read<ClassroomCubit>().fetchClassrooms(
                    studiId: studiId,
                  );
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ClassroomGetPublic kelas) {
    final nameCtrl = TextEditingController(text: kelas.name ?? '');
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Edit Kelas'),
        content: TextFormField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nama Kelas'),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogCtx).pop(), // ⬅️ pakai dialogCtx
            child: const Text('Batal'),
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;

              // (opsi A) Tutup dialog dulu baru proses -> aman dari double pop/gesture
              Navigator.of(dialogCtx).pop();

              final data = PutClassroomPublic(
                id: kelas.id,
                name: nameCtrl.text,
                studiId: kelas.studiId,
              );

              final cubit = context.read<ClassroomCubit>();
              await cubit.updateClassroom(kelas.id!, data, studiId: studiId);
              if (context.mounted) {
                cubit.fetchClassrooms(studiId: studiId);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Yakin ingin menghapus kelas ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                // simpan referensi sebelum await
                final cubit = context.read<ClassroomCubit>();
                final sid = studiId;

                await cubit.deleteClassroom(id, studiId: sid);

                if (context.mounted) {
                  await cubit.fetchClassrooms(studiId: sid);
                }

                if (dialogContext.mounted) {
                  Navigator.of(
                    dialogContext,
                  ).pop(); // tutup dialog dg context dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
}
