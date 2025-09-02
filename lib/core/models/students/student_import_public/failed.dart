import 'dart:convert';

import 'package:equatable/equatable.dart';

class Failed extends Equatable {
	final int? row;
	final String? name;
	final String? classroom;
	final String? ekskul;
	final String? error;

	const Failed({
		this.row, 
		this.name, 
		this.classroom, 
		this.ekskul, 
		this.error, 
	});

	factory Failed.fromMap(Map<String, dynamic> data) => Failed(
				row: data['row'] as int?,
				name: data['name'] as String?,
				classroom: data['classroom'] as String?,
				ekskul: data['ekskul'] as String?,
				error: data['error'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'row': row,
				'name': name,
				'classroom': classroom,
				'ekskul': ekskul,
				'error': error,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Failed].
	factory Failed.fromJson(String data) {
		return Failed.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Failed] to a JSON string.
	String toJson() => json.encode(toMap());

	Failed copyWith({
		int? row,
		String? name,
		String? classroom,
		String? ekskul,
		String? error,
	}) {
		return Failed(
			row: row ?? this.row,
			name: name ?? this.name,
			classroom: classroom ?? this.classroom,
			ekskul: ekskul ?? this.ekskul,
			error: error ?? this.error,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [row, name, classroom, ekskul, error];
}
