import 'package:attandance_simple/core/models/studi_public/studi_public.dart';
import 'package:equatable/equatable.dart';

class StudiState extends Equatable {
  final List<StudiPublic> data;
  final bool isLoading;
  final String? error;
  const StudiState({this.data = const [], this.isLoading = false, this.error});

  @override
  List<Object> get props => [data, isLoading, error ?? ''];

  StudiState copyWith({
    List<StudiPublic>? data,
    bool? isLoading,
    String? error,
  }) {
    return StudiState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
