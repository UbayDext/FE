import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'classroom.dart';
import 'ekskul.dart';
import 'studi.dart';

class Data extends Equatable {
	final String? name;
	final int? classroomId;
	final int? studiId;
	final int? ekskulId;
	final DateTime? updatedAt;
	final DateTime? createdAt;
	final int? id;
	final Classroom? classroom;
	final Ekskul? ekskul;
	final Studi? studi;

	const Data({
		this.name, 
		this.classroomId, 
		this.studiId, 
		this.ekskulId, 
		this.updatedAt, 
		this.createdAt, 
		this.id, 
		this.classroom, 
		this.ekskul, 
		this.studi, 
	});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				name: data['name'] as String?,
				classroomId: data['classroom_id'] as int?,
				studiId: data['studi_id'] as int?,
				ekskulId: data['ekskul_id'] as int?,
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				id: data['id'] as int?,
				classroom: data['classroom'] == null
						? null
						: Classroom.fromMap(data['classroom'] as Map<String, dynamic>),
				ekskul: data['ekskul'] == null
						? null
						: Ekskul.fromMap(data['ekskul'] as Map<String, dynamic>),
				studi: data['studi'] == null
						? null
						: Studi.fromMap(data['studi'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'name': name,
				'classroom_id': classroomId,
				'studi_id': studiId,
				'ekskul_id': ekskulId,
				'updated_at': updatedAt?.toIso8601String(),
				'created_at': createdAt?.toIso8601String(),
				'id': id,
				'classroom': classroom?.toMap(),
				'ekskul': ekskul?.toMap(),
				'studi': studi?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
	factory Data.fromJson(String data) {
		return Data.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
	String toJson() => json.encode(toMap());

	Data copyWith({
		String? name,
		int? classroomId,
		int? studiId,
		int? ekskulId,
		DateTime? updatedAt,
		DateTime? createdAt,
		int? id,
		Classroom? classroom,
		Ekskul? ekskul,
		Studi? studi,
	}) {
		return Data(
			name: name ?? this.name,
			classroomId: classroomId ?? this.classroomId,
			studiId: studiId ?? this.studiId,
			ekskulId: ekskulId ?? this.ekskulId,
			updatedAt: updatedAt ?? this.updatedAt,
			createdAt: createdAt ?? this.createdAt,
			id: id ?? this.id,
			classroom: classroom ?? this.classroom,
			ekskul: ekskul ?? this.ekskul,
			studi: studi ?? this.studi,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				name,
				classroomId,
				studiId,
				ekskulId,
				updatedAt,
				createdAt,
				id,
				classroom,
				ekskul,
				studi,
		];
	}
}
