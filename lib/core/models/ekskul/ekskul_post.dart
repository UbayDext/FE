import 'dart:convert';

import 'package:equatable/equatable.dart';

class EkskulPost extends Equatable {
	final String? namaEkskul;
	final int? studiId;
	final DateTime? updatedAt;
	final DateTime? createdAt;
	final int? id;

	const EkskulPost({
		this.namaEkskul, 
		this.studiId, 
		this.updatedAt, 
		this.createdAt, 
		this.id, 
	});

	factory EkskulPost.fromMap(Map<String, dynamic> data) => EkskulPost(
				namaEkskul: data['nama_ekskul'] as String?,
				studiId: data['studi_id'] as int?,
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				id: data['id'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'nama_ekskul': namaEkskul,
				'studi_id': studiId,
				'updated_at': updatedAt?.toIso8601String(),
				'created_at': createdAt?.toIso8601String(),
				'id': id,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EkskulPost].
	factory EkskulPost.fromJson(String data) {
		return EkskulPost.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [EkskulPost] to a JSON string.
	String toJson() => json.encode(toMap());

	EkskulPost copyWith({
		String? namaEkskul,
		int? studiId,
		DateTime? updatedAt,
		DateTime? createdAt,
		int? id,
	}) {
		return EkskulPost(
			namaEkskul: namaEkskul ?? this.namaEkskul,
			studiId: studiId ?? this.studiId,
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
				namaEkskul,
				studiId,
				updatedAt,
				createdAt,
				id,
		];
	}
}
