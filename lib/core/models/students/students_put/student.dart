import 'dart:convert';

import 'package:equatable/equatable.dart';

class Student extends Equatable {
	final int? id;
	final String? name;
	final int? studiId;
	final int? classroomId;
	final int? ekskulId;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Student({
		this.id, 
		this.name, 
		this.studiId, 
		this.classroomId, 
		this.ekskulId, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory Student.fromMap(Map<String, dynamic> data) => Student(
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
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'studi_id': studiId,
				'classroom_id': classroomId,
				'ekskul_id': ekskulId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Student].
	factory Student.fromJson(String data) {
		return Student.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Student] to a JSON string.
	String toJson() => json.encode(toMap());

	Student copyWith({
		int? id,
		String? name,
		int? studiId,
		int? classroomId,
		int? ekskulId,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Student(
			id: id ?? this.id,
			name: name ?? this.name,
			studiId: studiId ?? this.studiId,
			classroomId: classroomId ?? this.classroomId,
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
				studiId,
				classroomId,
				ekskulId,
				createdAt,
				updatedAt,
		];
	}
}
