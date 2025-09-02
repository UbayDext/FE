import 'package:attandance_simple/core/cubit/cubit_ekskul/ekskul_cubit_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_ekskul/ekskul_cubit_state.dart';
import 'package:attandance_simple/core/presentation/screen/date_ekskul_screen.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_get/ekskul_get.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_post.dart';
import 'package:attandance_simple/core/models/ekskul/ekskul_put.dart';
import 'package:attandance_simple/core/service/Ekskul_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EkskulScreen extends StatelessWidget {
  final int studiId;
  final String infoStudi;

  const EkskulScreen({Key? key, required this.studiId, required this.infoStudi})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          EkskulCubitCubit(EkskulService())..fetchEkskul(studiId: studiId),
      // ↓↓↓ gunakan Builder agar kita dapat context baru (ctx) yang SUDAH di bawah provider
      child: Builder(
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(title: Text('Ekskul $infoStudi')),
            body: BlocBuilder<EkskulCubitCubit, EkskulCubitState>(
              bloc: ctx.read<EkskulCubitCubit>(),
              builder: (ctx, state) {
                if (state is EkskulLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is EkskulError) {
                  return Center(child: Text('Error: ${state.msg}'));
                }
                if (state is EkskulLoaded) {
                  final list = state.list;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text('Belum ada Ekskul di studi ini.'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final ekskul = list[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(ekskul.namaEkskul ?? '-'),
                          subtitle: Text(
                            'Jumlah siswa: ${ekskul.studentsCount ?? 0}',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'edit') {
                                _showEditDialog(ctx, ekskul);
                              } else if (v == 'delete' && ekskul.id != null) {
                                _showDeleteDialog(ctx, ekskul.id!);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (ekskul.id == null) return;
                            Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => DateEkskulScreen(
                                  namaEkskul: ekskul.namaEkskul ?? '-',
                                  infoEkskul: ekskul.namaEkskul ?? '-',
                                  ekskulId: ekskul.id!, // filter ekskul
                                  studiId: studiId, // filter jenjang
                                  classroomId: 0, // 0/null = lintas kelas
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _showAddDialog(ctx),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext ctx) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: ctx,
      builder: (dialogCtx) => BlocProvider.value(
        value: ctx.read<EkskulCubitCubit>(),
        child: AlertDialog(
          title: const Text('Tambah Ekskul'),
          content: TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Nama Ekskul'),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogCtx, rootNavigator: true).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              child: const Text('Simpan'),
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;

                // Tutup dialog dulu
                Navigator.of(dialogCtx, rootNavigator: true).pop();

                // Lanjutkan proses di belakang layar
                ctx.read<EkskulCubitCubit>().createEkskul(
                  EkskulPost(namaEkskul: name, studiId: studiId),
                  studiId: studiId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext ctx, EkskulGet ekskul) {
    final nameCtrl = TextEditingController(text: ekskul.namaEkskul ?? '');
    showDialog(
      context: ctx,
      builder: (dialogCtx) => BlocProvider.value(
        value: ctx.read<EkskulCubitCubit>(),
        child: AlertDialog(
          title: const Text('Edit Ekskul'),
          content: TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Nama Ekskul'),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogCtx, rootNavigator: true).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty || ekskul.id == null) return;

                // TUTUP DULU
                Navigator.of(dialogCtx, rootNavigator: true).pop();

                // LALU TRIGGER UPDATE (tanpa await)
                ctx.read<EkskulCubitCubit>().updateEkskul(
                  ekskul.id!,
                  EkskulPut(
                    id: ekskul.id,
                    namaEkskul: name,
                    studiId: ekskul.studiId,
                  ),
                  studiId: studiId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext ctx, int id) {
    showDialog(
      context: ctx,
      builder: (dialogCtx) => BlocProvider.value(
        value: ctx.read<EkskulCubitCubit>(),
        child: AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Yakin ingin menghapus Ekskul ini?'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogCtx, rootNavigator: true).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Tutup dialog dulu
                Navigator.of(dialogCtx, rootNavigator: true).pop();

                // Lanjutkan proses di belakang layar
                ctx.read<EkskulCubitCubit>().deleteEkskul(id, studiId: studiId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
