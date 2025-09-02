import 'dart:convert';

import 'package:equatable/equatable.dart';

class DeletedTeamPublic extends Equatable {
	final bool? success;
	final String? message;

	const DeletedTeamPublic({this.success, this.message});

	factory DeletedTeamPublic.fromMap(Map<String, dynamic> data) {
		return DeletedTeamPublic(
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
  /// Parses the string and returns the resulting Json object as [DeletedTeamPublic].
	factory DeletedTeamPublic.fromJson(String data) {
		return DeletedTeamPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [DeletedTeamPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	DeletedTeamPublic copyWith({
		bool? success,
		String? message,
	}) {
		return DeletedTeamPublic(
			success: success ?? this.success,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message];
}
