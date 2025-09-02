import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'ekskul.dart';

class Datum extends Equatable {
	final int? id;
	final String? name;
	final String? status;
	final int? ekskulId;
	final DateTime? createdAt;
	final DateTime? updatedAt;
	final Ekskul? ekskul;

	const Datum({
		this.id, 
		this.name, 
		this.status, 
		this.ekskulId, 
		this.createdAt, 
		this.updatedAt, 
		this.ekskul, 
	});

	factory Datum.fromMap(Map<String, dynamic> data) => Datum(
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
				ekskul: data['ekskul'] == null
						? null
						: Ekskul.fromMap(data['ekskul'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'status': status,
				'ekskul_id': ekskulId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
				'ekskul': ekskul?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
	factory Datum.fromJson(String data) {
		return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
	String toJson() => json.encode(toMap());

	Datum copyWith({
		int? id,
		String? name,
		String? status,
		int? ekskulId,
		DateTime? createdAt,
		DateTime? updatedAt,
		Ekskul? ekskul,
	}) {
		return Datum(
			id: id ?? this.id,
			name: name ?? this.name,
			status: status ?? this.status,
			ekskulId: ekskulId ?? this.ekskulId,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
			ekskul: ekskul ?? this.ekskul,
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
				ekskul,
		];
	}
}
