import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'student.dart';

class StudentsPut extends Equatable {
	final String? status;
	final String? message;
	final Student? student;

	const StudentsPut({this.status, this.message, this.student});

	factory StudentsPut.fromMap(Map<String, dynamic> data) => StudentsPut(
				status: data['status'] as String?,
				message: data['message'] as String?,
				student: data['student'] == null
						? null
						: Student.fromMap(data['student'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'status': status,
				'message': message,
				'student': student?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StudentsPut].
	factory StudentsPut.fromJson(String data) {
		return StudentsPut.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [StudentsPut] to a JSON string.
	String toJson() => json.encode(toMap());

	StudentsPut copyWith({
		String? status,
		String? message,
		Student? student,
	}) {
		return StudentsPut(
			status: status ?? this.status,
			message: message ?? this.message,
			student: student ?? this.student,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [status, message, student];
}
