import 'dart:convert';

import 'package:equatable/equatable.dart';

class DeletedStudentPublic extends Equatable {
	final bool? success;
	final String? message;

	const DeletedStudentPublic({this.success, this.message});

	factory DeletedStudentPublic.fromMap(Map<String, dynamic> data) {
		return DeletedStudentPublic(
			success: data['success'] as bool?,
			message: data['message'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DeletedStudentPublic].
	factory DeletedStudentPublic.fromJson(String data) {
		return DeletedStudentPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [DeletedStudentPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	DeletedStudentPublic copyWith({
		bool? success,
		String? message,
	}) {
		return DeletedStudentPublic(
			success: success ?? this.success,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message];
}
