import 'dart:convert';

import 'package:equatable/equatable.dart';

class Datum extends Equatable {
	final int? id;
	final String? name;
	final int? ekskulId;

	const Datum({this.id, this.name, this.ekskulId});

	factory Datum.fromMap(Map<String, dynamic> data) => Datum(
				id: data['id'] as int?,
				name: data['name'] as String?,
				ekskulId: data['ekskul_id'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'ekskul_id': ekskulId,
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
		int? ekskulId,
	}) {
		return Datum(
			id: id ?? this.id,
			name: name ?? this.name,
			ekskulId: ekskulId ?? this.ekskulId,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, name, ekskulId];
}
