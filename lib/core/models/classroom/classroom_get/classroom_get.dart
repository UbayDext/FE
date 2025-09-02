import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'studi.dart';

class ClassroomGet extends Equatable {
	final int? id;
	final String? name;
	final dynamic jumlahSiswa;
	final int? studiId;
	final DateTime? createdAt;
	final DateTime? updatedAt;
	final int? studentsCount;
	final Studi? studi;

	const ClassroomGet({
		this.id, 
		this.name, 
		this.jumlahSiswa, 
		this.studiId, 
		this.createdAt, 
		this.updatedAt, 
		this.studentsCount, 
		this.studi, 
	});

	factory ClassroomGet.fromMap(Map<String, dynamic> data) => ClassroomGet(
				id: data['id'] as int?,
				name: data['name'] as String?,
				jumlahSiswa: data['jumlah_siswa'] as dynamic,
				studiId: data['studi_id'] as int?,
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
				studentsCount: data['students_count'] as int?,
				studi: data['studi'] == null
						? null
						: Studi.fromMap(data['studi'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'jumlah_siswa': jumlahSiswa,
				'studi_id': studiId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
				'students_count': studentsCount,
				'studi': studi?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ClassroomGet].
	factory ClassroomGet.fromJson(String data) {
		return ClassroomGet.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ClassroomGet] to a JSON string.
	String toJson() => json.encode(toMap());

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				id,
				name,
				jumlahSiswa,
				studiId,
				createdAt,
				updatedAt,
				studentsCount,
				studi,
		];
	}
}
