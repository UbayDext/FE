import 'dart:convert';

import 'package:equatable/equatable.dart';

class StudentDelete extends Equatable {
	final String? status;
	final String? message;

	const StudentDelete({this.status, this.message});

	factory StudentDelete.fromMap(Map<String, dynamic> data) => StudentDelete(
				status: data['status'] as String?,
				message: data['message'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'status': status,
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StudentDelete].
	factory StudentDelete.fromJson(String data) {
		return StudentDelete.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [StudentDelete] to a JSON string.
	String toJson() => json.encode(toMap());

	StudentDelete copyWith({
		String? status,
		String? message,
	}) {
		return StudentDelete(
			status: status ?? this.status,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [status, message];
}
