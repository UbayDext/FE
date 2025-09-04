// lib/core/component/buildProfile_components.dart
import 'package:flutter/material.dart';

class BuildprofileComponents extends StatelessWidget {
  final String name;
  final String role;


  final VoidCallback? onTap;


  final String? imageUrl;
  final String? imageAssets;

  final String? alias;

  const BuildprofileComponents({
    super.key,
    required this.name,
    required this.role,
    this.onTap,
    this.imageUrl,
    this.imageAssets,
    this.alias,
  });

  String _initialsFrom(String s) {
    final parts = s.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    final first = parts.first.characters.first.toUpperCase();
    final last  = parts.last.characters.first.toUpperCase();
    return '$first$last';
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan sumber gambar jika ada
    ImageProvider? provider;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      provider = NetworkImage(imageUrl!);
    } else if (imageAssets != null && imageAssets!.isNotEmpty) {
      provider = AssetImage(imageAssets!);
    }

    final String displayName =
        (alias != null && alias!.trim().isNotEmpty) ? alias!.trim() : name.trim();
    final String initials = _initialsFrom(displayName);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap, // <<— di sini onTap diletakkan
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: provider,               // kalau ada foto → pakai
                backgroundColor: const Color(0xFFE3F2FD), // fallback warna
                child: provider == null                  // kalau tidak ada foto → inisial
                    ? Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
