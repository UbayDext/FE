import 'package:attandance_simple/core/config/app_config.dart';

/// Ubah 127.0.0.1/localhost -> 10.0.2.2 (emulator), dan jadikan absolut jika relatif.
String toAbsoluteUrl(String raw) {
  if (raw.isEmpty) return raw;

  String u = raw.trim();

  // jika relatif -> gabungkan dengan base
  if (!u.startsWith('http://') && !u.startsWith('https://')) {
    u = u.startsWith('/') ? '${AppConfig.apiBase}$u' : '${AppConfig.apiBase}/$u';
  }

  // normalisasi host localhost/127.0.0.1 -> 10.0.2.2
  if (u.startsWith('http://127.0.0.1:')) {
    u = u.replaceFirst('http://127.0.0.1:', 'http://10.0.2.2:');
  } else if (u.startsWith('http://localhost:')) {
    u = u.replaceFirst('http://localhost:', 'http://10.0.2.2:');
  }

  return u;
}

bool isPdfUrl(String url) {
  final u = url.toLowerCase();
  return u.endsWith('.pdf') || u.contains('application/pdf');
}
