import 'dart:convert';

import 'package:equatable/equatable.dart';

class ResetPasswordPublic extends Equatable {
	final bool? success;
	final String? message;

	const ResetPasswordPublic({this.success, this.message});

	factory ResetPasswordPublic.fromMap(Map<String, dynamic> data) {
		return ResetPasswordPublic(
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
  /// Parses the string and returns the resulting Json object as [ResetPasswordPublic].
	factory ResetPasswordPublic.fromJson(String data) {
		return ResetPasswordPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ResetPasswordPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	ResetPasswordPublic copyWith({
		bool? success,
		String? message,
	}) {
		return ResetPasswordPublic(
			success: success ?? this.success,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message];
}
