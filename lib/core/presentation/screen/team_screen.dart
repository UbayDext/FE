import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/cubit/cubit_input_team/input_team_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_input_team/input_team_state.dart';
import 'package:attandance_simple/core/presentation/screen/bracket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamScreen extends StatefulWidget {
  final int lombadId;
  final String nameRace;
  final String ekskul;
  final String statusRace;

  const TeamScreen({
    Key? key,
    required this.lombadId,
    required this.nameRace,
    required this.statusRace,
    required this.ekskul,
  }) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeamInputCubit>().getTeams(widget.lombadId);
  }

  void _showAddGroupDialog() {
    final groupNameController = TextEditingController();
    final List<TextEditingController> teamControllers = List.generate(
      4,
      (_) => TextEditingController(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Tambah Group",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  labelText: "Nama Grup",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(
                teamControllers.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: teamControllers[i],
                    decoration: InputDecoration(
                      labelText: "Nama Team",
                      border: const OutlineInputBorder(),
                      prefixText: "${i + 1}. ",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              final groupName = groupNameController.text.trim();
              final teams = teamControllers.map((c) => c.text.trim()).toList();
              if (groupName.isNotEmpty && teams.every((t) => t.isNotEmpty)) {
                context.read<TeamInputCubit>().addTeam(
                  nameGroup: groupName,
                  nameTeam1: teams[0],
                  nameTeam2: teams[1],
                  nameTeam3: teams[2],
                  nameTeam4: teams[3],
                  lombadId: widget.lombadId,
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, dynamic group) {
    final teams = [
      group.nameTeam1 ?? '',
      group.nameTeam2 ?? '',
      group.nameTeam3 ?? '',
      group.nameTeam4 ?? '',
    ];

    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BracketScreen(
              namaLogo: "logo.png",
              ekskul: widget.ekskul,
              namaLomba: widget.nameRace,
              statusLomba: widget.statusRace,
              teamRaceId: group.id,
            ),
          ),
        );
        if (result == true) {
          context.read<TeamInputCubit>().getTeams(widget.lombadId);
        }
      },

      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    group.nameGroup ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...teams.map(
                    (team) => Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Text(
                        team,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2.5,
                      ),
                      child: Text(
                        'Champion ${group.champion?.isNotEmpty == true ? group.champion : 'Belum ada pemenang'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- DELETE ICON ---
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Hapus Group"),
                      content: Text(
                        "Apakah kamu yakin ingin menghapus group ${group.nameGroup}?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<TeamInputCubit>().deleteTeam(
                              group.id,
                              lombadId: widget.lombadId,
                            );
                            Navigator.of(ctx).pop();
                          },
                          child: const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorComponent.addColor,
        child: const Icon(Icons.add, color: ColorComponent.bgColor),
        onPressed: _showAddGroupDialog,
      ),
      body: Column(
        children: [
          // HEADER INFO
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              children: [
                Text(
                  'Ekskul: ${widget.ekskul}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Nama Lomba: ${widget.nameRace}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Status: ${widget.statusRace}',
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(),
          // GRID GROUP pakai Cubit
          Expanded(
            child: BlocBuilder<TeamInputCubit, TeamInputState>(
              builder: (context, state) {
                if (state is TeamInputLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TeamInputLoaded) {
                  final groups = state.teams.data ?? [];
                  if (groups.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada group.\nKlik tombol + untuk menambah.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16, top: 12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: groups.length,
                    itemBuilder: (context, i) {
                      final group = groups[i];
                      return _buildGroupCard(context, group);
                    },
                  );
                } else if (state is TeamInputError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
