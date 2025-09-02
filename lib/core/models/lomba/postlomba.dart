import 'dart:convert';

import 'package:equatable/equatable.dart';

class Postlomba extends Equatable {
	final String? name;
	final String? status;
	final int? ekskulId;
	final DateTime? updatedAt;
	final DateTime? createdAt;
	final int? id;

	const Postlomba({
		this.name, 
		this.status, 
		this.ekskulId, 
		this.updatedAt, 
		this.createdAt, 
		this.id, 
	});

	factory Postlomba.fromMap(Map<String, dynamic> data) => Postlomba(
				name: data['name'] as String?,
				status: data['status'] as String?,
				ekskulId: data['ekskul_id'] as int?,
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				id: data['id'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'name': name,
				'status': status,
				'ekskul_id': ekskulId,
				'updated_at': updatedAt?.toIso8601String(),
				'created_at': createdAt?.toIso8601String(),
				'id': id,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Postlomba].
	factory Postlomba.fromJson(String data) {
		return Postlomba.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Postlomba] to a JSON string.
	String toJson() => json.encode(toMap());

	Postlomba copyWith({
		String? name,
		String? status,
		int? ekskulId,
		DateTime? updatedAt,
		DateTime? createdAt,
		int? id,
	}) {
		return Postlomba(
			name: name ?? this.name,
			status: status ?? this.status,
			ekskulId: ekskulId ?? this.ekskulId,
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
				name,
				status,
				ekskulId,
				updatedAt,
				createdAt,
				id,
		];
	}
}
