class SiswaAbsensi {
  final int id;
  final String nama;
  final String? status; // 'H' | 'I' | 'S' | 'A' | null

  SiswaAbsensi({
    required this.id,
    required this.nama,
    this.status,
  });

  SiswaAbsensi copyWith({
    int? id,
    String? nama,
    String? status,
  }) {
    return SiswaAbsensi(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      status: status ?? this.status,
    );
  }
}
