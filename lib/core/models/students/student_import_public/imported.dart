import 'dart:convert';

import 'package:equatable/equatable.dart';

class Imported extends Equatable {
	final int? id;
	final String? name;
	final int? classroomId;
	final int? studiId;
	final int? ekskulId;

	const Imported({
		this.id, 
		this.name, 
		this.classroomId, 
		this.studiId, 
		this.ekskulId, 
	});

	factory Imported.fromMap(Map<String, dynamic> data) => Imported(
				id: data['id'] as int?,
				name: data['name'] as String?,
				classroomId: data['classroom_id'] as int?,
				studiId: data['studi_id'] as int?,
				ekskulId: data['ekskul_id'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'classroom_id': classroomId,
				'studi_id': studiId,
				'ekskul_id': ekskulId,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Imported].
	factory Imported.fromJson(String data) {
		return Imported.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Imported] to a JSON string.
	String toJson() => json.encode(toMap());

	Imported copyWith({
		int? id,
		String? name,
		int? classroomId,
		int? studiId,
		int? ekskulId,
	}) {
		return Imported(
			id: id ?? this.id,
			name: name ?? this.name,
			classroomId: classroomId ?? this.classroomId,
			studiId: studiId ?? this.studiId,
			ekskulId: ekskulId ?? this.ekskulId,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, name, classroomId, studiId, ekskulId];
}
