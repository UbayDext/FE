import 'dart:convert';

import 'package:equatable/equatable.dart';

class ForgotPasswordPublic extends Equatable {
	final bool? success;
	final String? message;
	final String? token;

	const ForgotPasswordPublic({this.success, this.message, this.token});

	factory ForgotPasswordPublic.fromMap(Map<String, dynamic> data) {
		return ForgotPasswordPublic(
			success: data['success'] as bool?,
			message: data['message'] as String?,
			token: data['token'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
				'token': token,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ForgotPasswordPublic].
	factory ForgotPasswordPublic.fromJson(String data) {
		return ForgotPasswordPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ForgotPasswordPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	ForgotPasswordPublic copyWith({
		bool? success,
		String? message,
		String? token,
	}) {
		return ForgotPasswordPublic(
			success: success ?? this.success,
			message: message ?? this.message,
			token: token ?? this.token,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message, token];
}
