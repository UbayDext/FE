import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/cubit/cubit/me_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_logout/logout_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_logout/logout_state.dart';
import 'package:attandance_simple/core/presentation/screen/setting_screen.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attandance_simple/core/service/Auth_service.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MeCubit(
        auth: AuthService(),
        storage: LocalStorage(),
      )..load(),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            BlocBuilder<MeCubit, MeState>(
              builder: (context, state) {
                if (state is MeLoading || state is MeInitial) {
                  return const UserAccountsDrawerHeader(
                    accountName: Text("Loading..."),
                    accountEmail: Text(""),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircularProgressIndicator(),
                    ),
                    decoration: BoxDecoration(color: Colors.blue),
                  );
                }

                if (state is MeLoaded) {
                  final me = state.me;
                  final name = me.username ?? '-';
                  final email = me.email ?? '-';
                  final initial = (name.isNotEmpty ? name[0] : 'U').toUpperCase();

                  return UserAccountsDrawerHeader(
                    accountName: Text(name),
                    accountEmail: Text(email),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        initial,
                        style: const TextStyle(fontSize: 40.0, color: Colors.blue),
                      ),
                    ),
                    decoration: const BoxDecoration(color: Colors.blue),
                  );
                }

                if (state is MeError) {
                  return UserAccountsDrawerHeader(
                    accountName: const Text("Unknown User"),
                    accountEmail: Text(state.message),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.error, color: Colors.red, size: 36),
                    ),
                    decoration: const BoxDecoration(color: Colors.blue),
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Students'),
              onTap: () => Navigator.pushNamed(context, '/siswa'),
            ),
            ListTile(
              leading: const Icon(Icons.sports_kabaddi),
              title: const Text('Ekskul'),
              onTap: () => Navigator.pushNamed(context, '/ekskul'),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('Competition'),
              onTap: () => Navigator.pushNamed(context, '/eksport'),
            ),
            ListTile(
              leading: const Icon(Icons.military_tech),
              title: const Text('Achievement'),
              onTap: () => Navigator.pushNamed(context, '/achievement'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              ),
            ),

            const Divider(),
            BlocConsumer<LogoutCubit, LogoutState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.logout, color: ColorComponent.warning),
                  title: const Text('Log-out', style: TextStyle(color: ColorComponent.warning)),
                  onTap: () async {
                    final token = await LocalStorage().getToken();
                    if (token != null && token.isNotEmpty) {
                      context.read<LogoutCubit>().logout(token);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token tidak ditemukan')),
                      );
                    }
                  },
                );
              },
              listener: (context, state) {
                if (state.isSucces) {
                  // bersihkan session kalau perlu
                  LocalStorage().clearSession();
                  Navigator.pushReplacementNamed(context, '/');
                } else if (state.error.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
