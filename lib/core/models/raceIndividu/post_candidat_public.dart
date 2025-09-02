import 'dart:convert';

import 'package:equatable/equatable.dart';

class PostCandidatPublic extends Equatable {
	final bool? success;
	final String? message;

	const PostCandidatPublic({this.success, this.message});

	factory PostCandidatPublic.fromMap(Map<String, dynamic> data) {
		return PostCandidatPublic(
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
  /// Parses the string and returns the resulting Json object as [PostCandidatPublic].
	factory PostCandidatPublic.fromJson(String data) {
		return PostCandidatPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [PostCandidatPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	PostCandidatPublic copyWith({
		bool? success,
		String? message,
	}) {
		return PostCandidatPublic(
			success: success ?? this.success,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message];
}
