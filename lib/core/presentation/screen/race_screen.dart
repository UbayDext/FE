import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/drawer_component.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_status/individu_status_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_lomba/lomba_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_lomba/lomba_state.dart';
import 'package:attandance_simple/core/dialog/lomba_form_dialog.dart';
import 'package:attandance_simple/core/models/lomba/get_lomba_pub/datum.dart';
import 'package:attandance_simple/core/service/individu_status_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'individu_screen.dart';
import 'team_screen.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<LombaCubit>().state.status == LombaStatus.initial) {
        context.read<LombaCubit>().fetchInitialData();
      }
    });
  }

  void _showFormDialog(BuildContext blocContext, {Datum? lomba}) async {
    // refresh dulu data sebelum buka dialog
    await blocContext.read<LombaCubit>().fetchInitialData();

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<LombaCubit>(blocContext),
        child: LombaFormDialog(lomba: lomba),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext blocContext, Datum lomba) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus lomba "${lomba.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              blocContext.read<LombaCubit>().removeLomba(lomba.id!);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      drawer: DrawerComponent(),
      body: BlocListener<LombaCubit, LombaState>(
        listenWhen: (previous, current) =>
            previous.actionStatus != current.actionStatus,
        listener: (context, state) {
          if (state.actionStatus == LombaActionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage ?? 'Aksi berhasil'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<LombaCubit>();
          }
          if (state.actionStatus == LombaActionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionError ?? 'Aksi gagal'),
                backgroundColor: Colors.red,
              ),
            );
            context.read<LombaCubit>();
          }
        },
        child: BlocBuilder<LombaCubit, LombaState>(
          builder: (context, state) {
            if (state.status == LombaStatus.loading &&
                state.lombaList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == LombaStatus.failure) {
              return Center(child: Text('Gagal memuat data: ${state.error}'));
            }
            if (state.lombaList.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada data Lomba.\nSilakan tambahkan melalui tombol +',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.lombaList.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (listViewContext, index) {
                final Datum lomba = state.lombaList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 20.0,
                    ),
                    title: Text(
                      lomba.name ?? 'Tanpa Nama',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Status: ${lomba.status ?? '-'}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lomba.ekskul?.namaEkskul ?? '-',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showFormDialog(context, lomba: lomba);
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(context, lomba);
                            }
                          },
                          itemBuilder: (popupContext) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      if (lomba.status == "Individu") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) =>
                                  IndividuStatusCubit(IndividuStatusService()),
                              child: IndividuScreen(
                                nameRace: lomba.name ?? '',
                                ekskul: lomba.ekskul?.namaEkskul ?? '',
                                statusRace: lomba.status ?? '',
                                ekskulId: lomba.ekskulId!,
                                lombadId: lomba.id!,
                              ),
                            ),
                          ),
                        );
                      } else if (lomba.status == "Team") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TeamScreen(
                              lombadId: lomba.id!,
                              nameRace: lomba.name ?? '',
                              ekskul: lomba.ekskul?.namaEkskul ?? '',
                              statusRace: lomba.status ?? '',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<LombaCubit, LombaState>(
        builder: (context, state) {
          // Tombol FAB hanya aktif jika data sudah selesai dimuat
          final bool isDataReady = state.status == LombaStatus.success;
          return FloatingActionButton(
            onPressed: isDataReady ? () => _showFormDialog(context) : null,
            backgroundColor: isDataReady ? Colors.blue : Colors.grey,
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}
