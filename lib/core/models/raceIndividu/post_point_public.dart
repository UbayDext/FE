import 'dart:convert';

import 'package:equatable/equatable.dart';

class PostPointPublic extends Equatable {
	final bool? success;
	final String? message;

	const PostPointPublic({this.success, this.message});

	factory PostPointPublic.fromMap(Map<String, dynamic> data) {
		return PostPointPublic(
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
  /// Parses the string and returns the resulting Json object as [PostPointPublic].
	factory PostPointPublic.fromJson(String data) {
		return PostPointPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [PostPointPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	PostPointPublic copyWith({
		bool? success,
		String? message,
	}) {
		return PostPointPublic(
			success: success ?? this.success,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message];
}
