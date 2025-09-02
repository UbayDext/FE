import 'dart:convert';

import 'package:equatable/equatable.dart';

class Student extends Equatable {
	final int? id;
	final String? name;

	const Student({this.id, this.name});

	factory Student.fromMap(Map<String, dynamic> data) => Student(
				id: data['id'] as int?,
				name: data['name'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
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
	}) {
		return Student(
			id: id ?? this.id,
			name: name ?? this.name,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, name];
}
