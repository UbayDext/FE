import 'dart:convert';

import 'package:equatable/equatable.dart';

class Studi extends Equatable {
	final int? id;
	final String? namaStudi;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Studi({this.id, this.namaStudi, this.createdAt, this.updatedAt});

	factory Studi.fromMap(Map<String, dynamic> data) => Studi(
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
  /// Parses the string and returns the resulting Json object as [Studi].
	factory Studi.fromJson(String data) {
		return Studi.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Studi] to a JSON string.
	String toJson() => json.encode(toMap());

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, namaStudi, createdAt, updatedAt];
}
