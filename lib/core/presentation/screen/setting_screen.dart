// lib/core/presentation/screen/setting_screen.dart
import 'package:attandance_simple/core/component/buildProfile_components.dart';
import 'package:attandance_simple/core/component/drawer_component.dart';
import 'package:attandance_simple/core/cubit/cubit/me_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_logout/logout_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_logout/logout_state.dart';
import 'package:attandance_simple/core/service/Auth_service.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogCtx) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin keluar dari akun ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogCtx).pop(),
            ),
            TextButton(
              child: const Text('Log-out', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final token = await LocalStorage().getToken();
                if (token != null && token.isNotEmpty) {
                  // pastikan LogoutCubit tersedia di tree (global atau di parent)
                  dialogCtx.read<LogoutCubit>().logout(token);
                } else {
                  ScaffoldMessenger.of(dialogCtx).showSnackBar(
                    const SnackBar(content: Text('Token tidak ditemukan')),
                  );
                }
                Navigator.of(dialogCtx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
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
              final initial = (name.isNotEmpty ? name[0] : 'U')
                  .toUpperCase(); // untuk avatar huruf

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  BuildprofileComponents(
                    name: name,
                    role: role,
                    alias:
                        initial, // komponen akan menampilkan huruf jika tidak ada foto
                  ),
                  const Divider(),

                  _buildSettingsListTile(
                    context: context,
                    icon: Icons.edit_outlined,
                    title: 'Edit Profil',
                    onTap: () => Navigator.pushNamed(context, '/editProfile'),
                  ),
                  _buildSettingsListTile(
                    context: context,
                    icon: Icons.lock_outline,
                    title: 'Ubah Password',
                    onTap: () =>
                        Navigator.pushNamed(context, '/forgotPassword'),
                  ),
                  _buildSettingsListTile(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),

                  const Divider(),

                  BlocConsumer<LogoutCubit, LogoutState>(
                    listener: (context, st) {
                      if (st.isSucces) {
                        Navigator.pushReplacementNamed(context, '/');
                      } else if (st.error.isNotEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(st.error)));
                      }
                    },
                    builder: (context, st) {
                      return ListTile(
                        leading: Icon(Icons.logout, color: Colors.red[700]),
                        title: Text(
                          'Log Out',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                        onTap: () => _showLogoutDialog(context),
                      );
                    },
                  ),
                ],
              );
            }

            if (state is MeError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            // Fallback WAJIB supaya builder selalu mengembalikan Widget
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSettingsListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
