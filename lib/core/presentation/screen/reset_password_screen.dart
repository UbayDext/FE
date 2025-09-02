import 'package:attandance_simple/core/cubit/cubit_reset_password/reset_password_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_reset_password/reset_password_state.dart';
import 'package:attandance_simple/core/presentation/screen/login_screen.dart';
import 'package:attandance_simple/core/service/Auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _token = '';
  bool _isLoadingData = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromPrefs();
  }

  Future<void> _loadDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _emailController.text = prefs.getString('reset_email') ?? '';
        _token = prefs.getString('reset_token') ?? '';
        _isLoadingData = false;
      });
    }
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reset_email');
    await prefs.remove('reset_token');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // void _submit() {
  //   if (!_formKey.currentState!.validate()) return;
  //   if (_token.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Token tidak ditemukan. Silakan ulangi proses.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }
  //   context.read<ResetPasswordCubit>().submitReset(
  //     email: _emailController.text.trim(),
  //     token: _token,
  //     password: _passwordController.text,
  //     passwordConfirmation: _confirmPasswordController.text,
  //   );
  // }

  void _submit(BuildContext ctx) {
    if (!_formKey.currentState!.validate()) return;
    if (_token.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Token tidak ditemukan. Silakan ulangi proses.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    ctx.read<ResetPasswordCubit>().submitReset(
      email: _emailController.text.trim(),
      token: _token,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(AuthService()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Atur Password Baru')),
            body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
              listener: (context, state) async {
                if (state is ResetPasswordFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (state is ResetPasswordSuccess) {
                  // final scaffoldMessenger = ScaffoldMessenger.of(context)
                  await _clearPrefs(); // reset email dan password
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                    'flash_login',
                    state.message,
                  ); // simpen sukses pake key "flash_login"
                  if (!mounted) return; // safety chek

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                    arguments: state.message,
                  );

                  // {
                  //   Navigator.pushNamedAndRemoveUntil(
                  //     context,
                  //     '/login',
                  //     (route) => false,
                  //     arguments: state.message,
                  //   );

                  //   scaffoldMessenger.showSnackBar(
                  //     SnackBar(
                  //       content: Text(state.message),
                  //       backgroundColor: Colors.green,
                  //     ),
                  //   );
                  // }
                }
              },
              child: _isLoadingData
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Silakan masukkan password baru Anda.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password Baru',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Password tidak boleh kosong';
                                if (v.length < 6)
                                  return 'Password minimal 6 karakter';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: 'Konfirmasi Password Baru',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Konfirmasi password tidak boleh kosong';
                                if (v != _passwordController.text)
                                  return 'Password tidak cocok';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                              builder: (context, state) {
                                if (state is ResetPasswordLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () => _submit(context),
                                  child: const Text('Reset Password'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
