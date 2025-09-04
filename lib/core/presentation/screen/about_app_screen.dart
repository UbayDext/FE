import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: const Center(
        child: Card(
          color: Colors.blue,
          margin: EdgeInsets.all(20),
          elevation: 5,
          child: Text(
            'Aplikasi Absensi Sederhana\n\nVersion 1.0.0\n\nDibuat oleh anak magang\n dengan waktu yang 3 bulan, mohon maaf atas waktu yang sangat lama tersebut',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
