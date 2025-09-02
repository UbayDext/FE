import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'student.dart';

class Datum extends Equatable {
	final int? id;
	final Student? student;
	final int? point1;
	final int? point2;
	final int? point3;
	final int? point4;
	final int? point5;
	final int? total;

	const Datum({
		this.id, 
		this.student, 
		this.point1, 
		this.point2, 
		this.point3, 
		this.point4, 
		this.point5, 
		this.total, 
	});

	factory Datum.fromMap(Map<String, dynamic> data) => Datum(
				id: data['id'] as int?,
				student: data['student'] == null
						? null
						: Student.fromMap(data['student'] as Map<String, dynamic>),
				point1: data['point1'] as int?,
				point2: data['point2'] as int?,
				point3: data['point3'] as int?,
				point4: data['point4'] as int?,
				point5: data['point5'] as int?,
				total: data['total'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'student': student?.toMap(),
				'point1': point1,
				'point2': point2,
				'point3': point3,
				'point4': point4,
				'point5': point5,
				'total': total,
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
		Student? student,
		int? point1,
		int? point2,
		int? point3,
		int? point4,
		int? point5,
		int? total,
	}) {
		return Datum(
			id: id ?? this.id,
			student: student ?? this.student,
			point1: point1 ?? this.point1,
			point2: point2 ?? this.point2,
			point3: point3 ?? this.point3,
			point4: point4 ?? this.point4,
			point5: point5 ?? this.point5,
			total: total ?? this.total,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				id,
				student,
				point1,
				point2,
				point3,
				point4,
				point5,
				total,
		];
	}
}
