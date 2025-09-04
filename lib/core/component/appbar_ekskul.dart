import 'package:attandance_simple/core/component/color_component.dart';
import 'package:flutter/material.dart';

class AppbarEkskul extends StatelessWidget implements PreferredSizeWidget {
  const AppbarEkskul({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Row(
        children: [
          const CircleAvatar(
            backgroundColor: ColorComponent.bgColor,
            child: Icon(
              Icons.assignment_turned_in_outlined,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Ekskul Attendance',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
