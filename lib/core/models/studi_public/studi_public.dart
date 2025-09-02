import 'dart:convert';

import 'package:equatable/equatable.dart';

class StudiPublic extends Equatable {
	final int? id;
	final String? namaStudi;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const StudiPublic({
		this.id, 
		this.namaStudi, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory StudiPublic.fromMap(Map<String, dynamic> data) => StudiPublic(
				id: data['id'] as int?,
				namaStudi: data['nama_studi'] as String?,
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'nama_studi': namaStudi,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StudiPublic].
	factory StudiPublic.fromJson(String data) {
		return StudiPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [StudiPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	StudiPublic copyWith({
		int? id,
		String? namaStudi,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return StudiPublic(
			id: id ?? this.id,
			namaStudi: namaStudi ?? this.namaStudi,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, namaStudi, createdAt, updatedAt];
}
