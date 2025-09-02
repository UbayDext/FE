import 'dart:convert';

import 'package:equatable/equatable.dart';

class PutClassroomPublic extends Equatable {
	final int? id;
	final String? name;
	final dynamic jumlahSiswa;
	final int? studiId;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const PutClassroomPublic({
		this.id, 
		this.name, 
		this.jumlahSiswa, 
		this.studiId, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory PutClassroomPublic.fromMap(Map<String, dynamic> data) {
		return PutClassroomPublic(
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
		);
	}



	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'jumlah_siswa': jumlahSiswa,
				'studi_id': studiId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PutClassroomPublic].
	factory PutClassroomPublic.fromJson(String data) {
		return PutClassroomPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [PutClassroomPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	PutClassroomPublic copyWith({
		int? id,
		String? name,
		dynamic jumlahSiswa,
		int? studiId,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return PutClassroomPublic(
			id: id ?? this.id,
			name: name ?? this.name,
			jumlahSiswa: jumlahSiswa ?? this.jumlahSiswa,
			studiId: studiId ?? this.studiId,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
		);
	}

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
		];
	}
}
