import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:flutter/material.dart';

class InfoEkskulScreen extends StatefulWidget {
  const InfoEkskulScreen({super.key});
  @override
  State<InfoEkskulScreen> createState() => _InfoEkskulScreenState();
}

class _InfoEkskulScreenState extends State<InfoEkskulScreen> {
  bool _pressedAttendance = false;
  bool _pressedLomba = false;
  static const _radius = 18.0;

  void _go(String localRoute) {
    setState(() {
      _pressedAttendance = false;
      _pressedLomba = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // PENTING: push ke navigator DALAM TAB
      Navigator.of(context, rootNavigator: false).pushNamed(localRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom + 80;
    return Scaffold(
      appBar: AppbarComponent(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(10, 16, 10, bottomSafe),
        children: [
          // Ekskul Attendance -> '/attendance'
          AnimatedScale(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            scale: _pressedAttendance ? 0.98 : 1.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
              elevation: _pressedAttendance ? 1 : 4,
              margin: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(_radius),
                onTapDown: (_) => setState(() => _pressedAttendance = true),
                onTapCancel: () => setState(() => _pressedAttendance = false),
                onTap: () => _go('/ekskul'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 28,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(width: 24),
                      Text(
                        'Ekskul Attendance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Lomba -> '/competition'
          AnimatedScale(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            scale: _pressedLomba ? 0.98 : 1.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
              elevation: _pressedLomba ? 1 : 4,
              margin: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(_radius),
                onTapDown: (_) => setState(() => _pressedLomba = true),
                onTapCancel: () => setState(() => _pressedLomba = false),
                onTap: () => _go('/lomba'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black12,
                        child: Icon(
                          Icons.emoji_events,
                          size: 28,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(width: 24),
                      Text(
                        'Lomba',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
