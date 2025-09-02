import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'classroom.dart';
import 'ekskul.dart';
import 'studi.dart';

class Data extends Equatable {
	final int? id;
	final String? name;
	final int? studiId;
	final int? classroomId;
	final int? ekskulId;
	final DateTime? createdAt;
	final DateTime? updatedAt;
	final Classroom? classroom;
	final Ekskul? ekskul;
	final Studi? studi;

	const Data({
		this.id, 
		this.name, 
		this.studiId, 
		this.classroomId, 
		this.ekskulId, 
		this.createdAt, 
		this.updatedAt, 
		this.classroom, 
		this.ekskul, 
		this.studi, 
	});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				id: data['id'] as int?,
				name: data['name'] as String?,
				studiId: data['studi_id'] as int?,
				classroomId: data['classroom_id'] as int?,
				ekskulId: data['ekskul_id'] as int?,
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
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
				'id': id,
				'name': name,
				'studi_id': studiId,
				'classroom_id': classroomId,
				'ekskul_id': ekskulId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
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
		int? id,
		String? name,
		int? studiId,
		int? classroomId,
		int? ekskulId,
		DateTime? createdAt,
		DateTime? updatedAt,
		Classroom? classroom,
		Ekskul? ekskul,
		Studi? studi,
	}) {
		return Data(
			id: id ?? this.id,
			name: name ?? this.name,
			studiId: studiId ?? this.studiId,
			classroomId: classroomId ?? this.classroomId,
			ekskulId: ekskulId ?? this.ekskulId,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
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
				id,
				name,
				studiId,
				classroomId,
				ekskulId,
				createdAt,
				updatedAt,
				classroom,
				ekskul,
				studi,
		];
	}
}
