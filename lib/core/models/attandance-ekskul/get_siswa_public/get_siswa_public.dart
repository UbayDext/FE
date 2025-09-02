import 'dart:convert';
import 'package:equatable/equatable.dart';

class GetSiswaPublic extends Equatable {
  final int? studentId;
  final String? name;
  final String? status; // <- String? biar aman di UI

  const GetSiswaPublic({
    this.studentId,
    this.name,
    this.status,
  });

  factory GetSiswaPublic.fromMap(Map<String, dynamic> data) {
    return GetSiswaPublic(
      studentId: data['student_id'] as int?,
      name: data['name'] as String?,
      status: data['status'] == null ? null : data['status'].toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'student_id': studentId,
        'name': name,
        'status': status,
      };

  factory GetSiswaPublic.fromJson(String data) =>
      GetSiswaPublic.fromMap(json.decode(data) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  GetSiswaPublic copyWith({
    int? studentId,
    String? name,
    String? status,
  }) {
    return GetSiswaPublic(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [studentId, name, status];
}

// OPSIONAL: kalau ada file lama yang masih menyebut GetStudentPublic
typedef GetStudentPublic = GetSiswaPublic;
