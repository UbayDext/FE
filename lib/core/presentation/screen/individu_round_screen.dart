import 'package:attandance_simple/core/component/appbar_lomba.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_participants/individu_participants_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_participants/individu_participants_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attandance_simple/core/component/appBar_component.dart';

import 'package:attandance_simple/core/models/raceIndividu/get_candidat_public/datum.dart'
    as cand;
import 'package:attandance_simple/core/models/raceIndividu/get_confirm_candidat/datum.dart'
    as art;

class IndividuRoundScreen extends StatefulWidget {
  final int raceId;
  final String namaLogo;
  final String ekskul;
  final String namaLomba;
  final String statusLomba;
  final int pointCount;
  final String roundName;

  const IndividuRoundScreen({
    Key? key,
    required this.raceId,
    required this.namaLogo,
    required this.ekskul,
    required this.namaLomba,
    required this.statusLomba,
    this.pointCount = 5,
    required this.roundName,
  }) : super(key: key);

  @override
  State<IndividuRoundScreen> createState() => _IndividuRoundScreenState();
}

class _IndividuRoundScreenState extends State<IndividuRoundScreen> {
  bool get isStatusSelesai => widget.statusLomba.toLowerCase() == 'selesai';

  @override
  void initState() {
    super.initState();
    final c = context.read<IndividuParticipantsCubit>();
    c.fetchParticipants(raceId: widget.raceId);
    c.fetchCandidates(raceId: widget.raceId);
  }

  Future<void> _openAddParticipantDialog(
    BuildContext pageContext,
    List<cand.Datum> candidates,
  ) async {
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(pageContext).showSnackBar(
        const SnackBar(content: Text('Tidak ada kandidat untuk ditambahkan')),
      );
      return;
    }

    final selected = List<bool>.filled(candidates.length, false);

    await showDialog(
      context: pageContext,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Tambah Peserta'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: candidates.length,
              itemBuilder: (ctx, i) => CheckboxListTile(
                title: Text(candidates[i].name ?? '-'),
                value: selected[i],
                onChanged: (v) => setS(() => selected[i] = v ?? false),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            TextButton(
              child: const Text('Simpan'),
              onPressed: () async {
                final ids = <int>[];
                for (int i = 0; i < candidates.length; i++) {
                  if (selected[i] && candidates[i].id != null) {
                    ids.add(candidates[i].id!);
                  }
                }
                if (ids.isEmpty) {
                  ScaffoldMessenger.of(pageContext).showSnackBar(
                    const SnackBar(content: Text('Pilih minimal satu kandidat')),
                  );
                  return;
                }
                await pageContext
                    .read<IndividuParticipantsCubit>()
                    .addParticipants(raceId: widget.raceId, studentIds: ids);
                if (mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _increasePoint(
    BuildContext pageContext, {
    required art.Datum peserta,
    required int pointIndex,
  }) {
    if (isStatusSelesai) return;

    int getVal(int? x) => x ?? 0;
    final List<int> current = [
      getVal(peserta.point1),
      getVal(peserta.point2),
      getVal(peserta.point3),
      getVal(peserta.point4),
      getVal(peserta.point5),
    ];

    if (pointIndex < 0 || pointIndex >= current.length) return;

    final int next = (current[pointIndex] + 5).clamp(0, 95);
    if (next == current[pointIndex]) return;

    final cubit = pageContext.read<IndividuParticipantsCubit>();
    cubit.updateParticipantPoints(
      raceId: widget.raceId,
      participantId: peserta.id!,
      point1: pointIndex == 0 ? next : null,
      point2: pointIndex == 1 ? next : null,
      point3: pointIndex == 2 ? next : null,
      point4: pointIndex == 3 ? next : null,
      point5: pointIndex == 4 ? next : null,
      refetchAfter: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IndividuParticipantsCubit, IndividuParticipantsState>(
      listenWhen: (p, c) => p.actionStatus != c.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == ActionStatus.success) {
          final msg = state.actionMessage ?? 'Aksi berhasil';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.green),
          );
          context.read<IndividuParticipantsCubit>().clearAction();
        } else if (state.actionStatus == ActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionError ?? 'Aksi gagal'),
              backgroundColor: Colors.red,
            ),
          );
          context.read<IndividuParticipantsCubit>().clearAction();
        }
      },
      child: Scaffold(
        appBar: AppbarLomba(),
        floatingActionButton: isStatusSelesai
            ? null
            : BlocBuilder<IndividuParticipantsCubit, IndividuParticipantsState>(
                buildWhen: (p, c) => p.candidatesStatus != c.candidatesStatus,
                builder: (context, state) {
                  return FloatingActionButton(
                    onPressed: () =>
                        _openAddParticipantDialog(context, state.candidates),
                    child: const Icon(Icons.add),
                  );
                },
              ),
        body: BlocBuilder<IndividuParticipantsCubit, IndividuParticipantsState>(
          builder: (context, state) {
            final loading =
                state.participantsStatus == DataStatus.loading &&
                state.participants.isEmpty;

            if (loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.participantsStatus == DataStatus.failure) {
              return Center(
                child: Text(
                  'Gagal memuat peserta: ${state.participantsError ?? '-'}',
                ),
              );
            }
            final list = List<art.Datum>.from(state.participants);

            if (isStatusSelesai) {
              list.sort((a, b) => (b.total ?? 0).compareTo(a.total ?? 0));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER INFO
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.ekskul,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(widget.namaLomba,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      Text(widget.statusLomba,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      Text(widget.roundName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // TABLE HEADER
                Container(
                  color: Colors.grey[100],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      const SizedBox(width: 28, child: Text('No')),
                      const Expanded(flex: 2, child: Text('Nama')),
                      if (!isStatusSelesai)
                        ...List.generate(
                          widget.pointCount,
                          (i) => Expanded(
                            child: Text(
                              'Point\n${i + 1}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                      else
                        const Expanded(
                          child: Text('Total Score',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),

                // LIST PESERTA
                Expanded(
                  child: list.isEmpty
                      ? const Center(child: Text('Belum ada peserta.'))
                      : ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1),
                          itemBuilder: (ctx, i) {
                            final peserta = list[i];
                            final nama = peserta.student?.name ?? '-';
                            final pts = [
                              peserta.point1 ?? 0,
                              peserta.point2 ?? 0,
                              peserta.point3 ?? 0,
                              peserta.point4 ?? 0,
                              peserta.point5 ?? 0,
                            ];
                            final total =
                                peserta.total ??
                                pts.fold<int>(0, (p, n) => p + n);

                            return Row(
                              children: [
                                SizedBox(width: 28, child: Text('${i + 1}')),
                                Expanded(flex: 2, child: Text(nama)),
                                if (!isStatusSelesai)
                                  ...List.generate(widget.pointCount, (j) {
                                    final val = (j < pts.length) ? pts[j] : 0;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => _increasePoint(
                                          context,
                                          peserta: peserta,
                                          pointIndex: j,
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            val.toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                else
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        total.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
