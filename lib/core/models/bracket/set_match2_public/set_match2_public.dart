import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'data.dart';

class SetMatch2Public extends Equatable {
	final bool? success;
	final String? message;
	final Data? data;

	const SetMatch2Public({this.success, this.message, this.data});

	factory SetMatch2Public.fromMap(Map<String, dynamic> data) {
		return SetMatch2Public(
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
  /// Parses the string and returns the resulting Json object as [SetMatch2Public].
	factory SetMatch2Public.fromJson(String data) {
		return SetMatch2Public.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [SetMatch2Public] to a JSON string.
	String toJson() => json.encode(toMap());

	SetMatch2Public copyWith({
		bool? success,
		String? message,
		Data? data,
	}) {
		return SetMatch2Public(
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
