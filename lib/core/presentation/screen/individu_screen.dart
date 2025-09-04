import 'package:attandance_simple/core/component/appbar_lomba.dart';
import 'package:attandance_simple/core/models/individu/get_individu_public/datum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_status/individu_status_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_status/individu_status_state.dart';
import 'package:attandance_simple/core/dialog/individu_form_dialog.dart';

import 'individu_round_screen.dart';

class IndividuScreen extends StatefulWidget {
  final String nameRace;
  final String ekskul;
  final String statusRace;
  final int ekskulId;
  final int lombadId;

  const IndividuScreen({
    super.key,
    required this.nameRace,
    required this.statusRace,
    required this.ekskul,
    required this.ekskulId,
    required this.lombadId,
  });

  @override
  State<IndividuScreen> createState() => _IndividuScreenState();
}

class _IndividuScreenState extends State<IndividuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<IndividuStatusCubit>();
      if (cubit.state.status == DataStatus.initial) {
        cubit.fetchIndividuLomba(lombadId: widget.lombadId);
      }
    });
  }

  void _openForm(BuildContext blocContext, {Datum? lomba}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<IndividuStatusCubit>(blocContext),
        child: IndividuFormDialog(
          lomba: lomba,
          ekskulId: widget.ekskulId,
          lombadId: widget.lombadId,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext blocContext, Datum lomba) {
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('Hapus Babak'),
        content: Text('Anda yakin ingin menghapus babak "${lomba.nameLomba}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              blocContext.read<IndividuStatusCubit>().deleteIndividuLomba(
                lomba.id!,
                lombaId: widget.lombadId,
              );
              Navigator.pop(dctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _effectiveStatus(Datum lomba) {
    final raw = lomba.statusRaw?.toLowerCase();
    if (lomba.endDate == null || raw != 'berlangsung') {
      return lomba.status ?? '-';
    }
    try {
      final end = DateFormat('yyyy-MM-dd').parse(lomba.endDate!);
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      return today.isAfter(end) ? 'Selesai' : (lomba.status ?? '-');
    } catch (_) {
      return lomba.status ?? '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IndividuStatusCubit, IndividuStatusState>(
      listenWhen: (p, c) => p.actionStatus != c.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == ActionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'Aksi berhasil'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<IndividuStatusCubit>().clearActionStatus();
        } else if (state.actionStatus == ActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionError ?? 'Aksi gagal'),
              backgroundColor: Colors.red,
            ),
          );
          context.read<IndividuStatusCubit>().clearActionStatus();
        }
      },
      child: BlocBuilder<IndividuStatusCubit, IndividuStatusState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppbarLomba(),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorComponent.addColor,
              onPressed: state.status == DataStatus.success
                  ? () => _openForm(context)
                  : null,
              child: const Icon(Icons.add, color: ColorComponent.bgColor),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.ekskul,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.nameRace,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Status: ${widget.statusRace}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(child: _buildList(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, IndividuStatusState state) {
    if (state.status == DataStatus.loading && state.lombaList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == DataStatus.failure) {
      return Center(child: Text('Gagal memuat data: ${state.error ?? '-'}'));
    }
    if (state.lombaList.isEmpty) {
      return const Center(child: Text('Belum ada babak.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.lombaList.length,
      itemBuilder: (ctx, i) {
        final lomba = state.lombaList[i];
        final statusDisp = _effectiveStatus(lomba);
        final isRun = statusDisp.toLowerCase() == 'berlangsung';
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            title: Text(
              lomba.nameLomba ?? 'Tanpa Nama',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text('Mulai: ${lomba.startDate ?? '-'}'),
                const SizedBox(height: 10),
                Text('Selesai: ${lomba.endDate ?? '-'}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isRun
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusDisp,
                    style: TextStyle(
                      fontSize: 15,
                      color: isRun ? Colors.orange : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (val) {
                    if (val == 'edit') _openForm(context, lomba: lomba);
                    if (val == 'delete') _confirmDelete(context, lomba);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                ),
              ],
            ),
            onTap: () {
              final raceId = lomba.id!;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IndividuRoundScreen(
                    namaLogo: 'Nama Logo',
                    ekskul: widget.ekskul,
                    namaLomba: widget.nameRace,
                    statusLomba: statusDisp,
                    pointCount: 5,
                    roundName: lomba.nameLomba ?? '',
                    raceId: raceId,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
