import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/buildProfile_components.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/component/drawer_component.dart';
import 'package:attandance_simple/core/cubit/cubit/me_cubit.dart';
import 'package:attandance_simple/core/presentation/screen/achievement_screen.dart';
import 'package:attandance_simple/core/presentation/screen/race_screen.dart';
import 'package:attandance_simple/core/presentation/screen/studi_ekskul_screen.dart';
import 'package:attandance_simple/core/presentation/screen/studi_screen.dart';
import 'package:attandance_simple/core/service/Auth_service.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToPage(String label) {
    Widget? page;

    switch (label) {
      case 'Ekskul':
        page = const StudiEkskulScreen();
        break;
      case 'Competition':
        page = const RaceScreen();
        break;
      case 'Achievement':
        // page = const AchievementScreen();
        break;
      case 'Students':
        page = const StudiScreen();
        break;
    }

    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: BlocProvider(
        create: (_) =>
            MeCubit(auth: AuthService(), storage: LocalStorage())..load(),
        child: BlocBuilder<MeCubit, MeState>(
          builder: (context, state) {
            if (state is MeLoading || state is MeInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MeLoaded) {
              final me = state.me;
              final name = me.username ?? 'User';
              final role = (me.role?.toString() ?? 'Role');

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildprofileComponents(
                        name: name,
                        role: role,
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildMenuGrid(),
                    ],
                  ),
                ),
              );
            }

            if (state is MeError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    final List<Map<String, dynamic>> menuItems = [
      {'label': 'Students', 'icon': Icons.group},
      {'label': 'Achievement', 'icon': Icons.military_tech},
      {'label': 'Ekskul', 'icon': Icons.sports_kabaddi},
      {'label': 'Competition', 'icon': Icons.emoji_events},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuButton(
          label: item['label'],
          icon: item['icon'],

          onTap: () => _navigateToPage(item['label']),
        );
      },
    );
  }

  Widget _buildMenuButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(icon, color: ColorComponent.iconColor),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
