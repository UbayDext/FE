import 'dart:convert';

import 'package:equatable/equatable.dart';

class DeletedClassroomPublic extends Equatable {
	final String? message;

	const DeletedClassroomPublic({this.message});

	factory DeletedClassroomPublic.fromMap(Map<String, dynamic> data) {
		return DeletedClassroomPublic(
			message: data['message'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DeletedClassroomPublic].
	factory DeletedClassroomPublic.fromJson(String data) {
		return DeletedClassroomPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [DeletedClassroomPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	DeletedClassroomPublic copyWith({
		String? message,
	}) {
		return DeletedClassroomPublic(
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [message];
}
