import 'dart:convert';

import 'package:equatable/equatable.dart';

class UpdateStatusPublic extends Equatable {
	final int? studentId;
	final int? ekskulId;
	final DateTime? tanggal;
	final int? studiId;
	final String? status;
	final DateTime? updatedAt;
	final DateTime? createdAt;
	final int? id;

	const UpdateStatusPublic({
		this.studentId, 
		this.ekskulId, 
		this.tanggal, 
		this.studiId, 
		this.status, 
		this.updatedAt, 
		this.createdAt, 
		this.id, 
	});

	factory UpdateStatusPublic.fromMap(Map<String, dynamic> data) {
		return UpdateStatusPublic(
			studentId: data['student_id'] as int?,
			ekskulId: data['ekskul_id'] as int?,
			tanggal: data['tanggal'] == null
						? null
						: DateTime.parse(data['tanggal'] as String),
			studiId: data['studi_id'] as int?,
			status: data['status'] as String?,
			updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
			createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
			id: data['id'] as int?,
		);
	}



	Map<String, dynamic> toMap() => {
				'student_id': studentId,
				'ekskul_id': ekskulId,
				'tanggal': tanggal?.toIso8601String(),
				'studi_id': studiId,
				'status': status,
				'updated_at': updatedAt?.toIso8601String(),
				'created_at': createdAt?.toIso8601String(),
				'id': id,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UpdateStatusPublic].
	factory UpdateStatusPublic.fromJson(String data) {
		return UpdateStatusPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [UpdateStatusPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	UpdateStatusPublic copyWith({
		int? studentId,
		int? ekskulId,
		DateTime? tanggal,
		int? studiId,
		String? status,
		DateTime? updatedAt,
		DateTime? createdAt,
		int? id,
	}) {
		return UpdateStatusPublic(
			studentId: studentId ?? this.studentId,
			ekskulId: ekskulId ?? this.ekskulId,
			tanggal: tanggal ?? this.tanggal,
			studiId: studiId ?? this.studiId,
			status: status ?? this.status,
			updatedAt: updatedAt ?? this.updatedAt,
			createdAt: createdAt ?? this.createdAt,
			id: id ?? this.id,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				studentId,
				ekskulId,
				tanggal,
				studiId,
				status,
				updatedAt,
				createdAt,
				id,
		];
	}
}
