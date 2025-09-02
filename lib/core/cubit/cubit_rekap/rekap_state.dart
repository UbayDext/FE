import 'package:equatable/equatable.dart';

class RekapState extends Equatable {
  final DateTime selectedDate;
  final bool loading;
  final String? error;
  final int h; // Hadir
  final int i; // Izin
  final int s; // Sakit
  final int a; // Alpa

  const RekapState({
    required this.selectedDate,
    this.loading = false,
    this.error,
    this.h = 0,
    this.i = 0,
    this.s = 0,
    this.a = 0,
  });

  RekapState copyWith({
    DateTime? selectedDate,
    bool? loading,
    String? error,
    int? h,
    int? i,
    int? s,
    int? a,
  }) {
    return RekapState(
      selectedDate: selectedDate ?? this.selectedDate,
      loading: loading ?? this.loading,
      error: error,
      h: h ?? this.h,
      i: i ?? this.i,
      s: s ?? this.s,
      a: a ?? this.a,
    );
  }

  @override
  List<Object?> get props => [selectedDate, loading, error, h, i, s, a];
}
