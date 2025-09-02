import 'package:attandance_simple/core/component/drawer_component.dart';
import 'package:attandance_simple/core/cubit/cubit_logout/logout_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_logout/logout_state.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log-out', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final token = await LocalStorage().getToken();
                if (token != null && token.isNotEmpty) {
                  context.read<LogoutCubit>().logout(token);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Token tidak ditemukan')),
                  );
                }
                Navigator.of(context).pop();
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
      drawer: DrawerComponent(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/Untitled.jpg'),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Penguji',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cabang Penguji',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          _buildSettingsListTile(
            context: context,
            icon: Icons.edit_outlined,
            title: 'Edit Profil',
            onTap: () {
              Navigator.pushNamed(context, '/editProfile');
            },
          ),
          _buildSettingsListTile(
            context: context,
            icon: Icons.lock_outline,
            title: 'Ubah Password',
            onTap: () {
              Navigator.pushNamed(context, '/forgotPassword');
            },
          ),
          _buildSettingsListTile(
            context: context,
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () {},
          ),

          const Divider(),

          BlocConsumer<LogoutCubit, LogoutState>(
            builder: (context, state) {
              return ListTile(
                leading: Icon(Icons.logout, color: Colors.red[700]),
                title: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red[700]),
                ),
                onTap: () => _showLogoutDialog(context),
              );
            },
            listener: (context, state) {
              if (state.isSucces) {
                Navigator.pushReplacementNamed(context, '/');
              } else if (state.error.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
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
