import 'dart:convert';

import 'package:equatable/equatable.dart';

class Putlomba extends Equatable {
	final int? id;
	final String? name;
	final String? status;
	final int? ekskulId;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Putlomba({
		this.id, 
		this.name, 
		this.status, 
		this.ekskulId, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory Putlomba.fromMap(Map<String, dynamic> data) => Putlomba(
				id: data['id'] as int?,
				name: data['name'] as String?,
				status: data['status'] as String?,
				ekskulId: data['ekskul_id'] as int?,
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'status': status,
				'ekskul_id': ekskulId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Putlomba].
	factory Putlomba.fromJson(String data) {
		return Putlomba.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Putlomba] to a JSON string.
	String toJson() => json.encode(toMap());

	Putlomba copyWith({
		int? id,
		String? name,
		String? status,
		int? ekskulId,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Putlomba(
			id: id ?? this.id,
			name: name ?? this.name,
			status: status ?? this.status,
			ekskulId: ekskulId ?? this.ekskulId,
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
				status,
				ekskulId,
				createdAt,
				updatedAt,
		];
	}
}
