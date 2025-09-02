import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/drawer_component.dart';
import 'package:attandance_simple/core/cubit/cubit_studi/studi_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_studi/studi_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'class_screen.dart';

class StudiScreen extends StatefulWidget {
  const StudiScreen({super.key});

  @override
  State<StudiScreen> createState() => _StudiScreenState();
}

class _StudiScreenState extends State<StudiScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudiCubit>().fetchStudi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      drawer: DrawerComponent(),
      body: BlocBuilder<StudiCubit, StudiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }
          if (state.data.isEmpty) {
            return Center(child: Text('Tidak ada data studi'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            itemCount: state.data.length,
            itemBuilder: (context, i) {
              final studi = state.data[i];
              return _buildJenjangCard(
                context,
                label: studi.namaStudi ?? '',
                icon: _iconByLabel(studi.namaStudi ?? ''),
                studiId: studi.id,
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconByLabel(String label) {
    switch (label.toLowerCase()) {
      case "tkit":
        return Icons.child_friendly;
      case "sdit":
        return Icons.menu_book;
      case "smpit":
        return Icons.school;
      default:
        return Icons.school_outlined;
    }
  }

  Widget _buildJenjangCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required int? studiId,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassScreen(                        
                studiId: studiId ?? 0,
                infoStudi: label,
                classInfo: label,
                ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: Icon(icon, size: 28, color: Colors.grey[700]),
              ),
              const SizedBox(width: 24),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
