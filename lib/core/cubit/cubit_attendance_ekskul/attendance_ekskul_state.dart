import 'package:equatable/equatable.dart';
import 'package:attandance_simple/core/models/attandance-ekskul/get_siswa_public/get_siswa_public.dart';

class AttendanceEkskulState extends Equatable {
  final bool loading;
  final bool saving;
  final String? error;
  final List<GetSiswaPublic> daftar;

  const AttendanceEkskulState({
    this.loading = false,
    this.saving = false,
    this.error,
    this.daftar = const [],
  });

  AttendanceEkskulState copyWith({
    bool? loading,
    bool? saving,
    String? error,
    List<GetSiswaPublic>? daftar,
    bool clearError = false,
  }) {
    return AttendanceEkskulState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      error: clearError ? null : (error ?? this.error),
      daftar: daftar ?? this.daftar,
    );
  }

  @override
  List<Object?> get props => [loading, saving, error, daftar];
}
