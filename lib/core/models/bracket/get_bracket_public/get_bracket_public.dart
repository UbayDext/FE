import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'data.dart';

class GetBracketPublic extends Equatable {
	final bool? success;
	final String? message;
	final Data? data;

	const GetBracketPublic({this.success, this.message, this.data});

	factory GetBracketPublic.fromMap(Map<String, dynamic> data) {
		return GetBracketPublic(
			success: data['success'] as bool?,
			message: data['message'] as String?,
			data: data['data'] == null
						? null
						: Data.fromMap(data['data'] as Map<String, dynamic>),
		);
	}



	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
				'data': data?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetBracketPublic].
	factory GetBracketPublic.fromJson(String data) {
		return GetBracketPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [GetBracketPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	GetBracketPublic copyWith({
		bool? success,
		String? message,
		Data? data,
	}) {
		return GetBracketPublic(
			success: success ?? this.success,
			message: message ?? this.message,
			data: data ?? this.data,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message, data];
}
