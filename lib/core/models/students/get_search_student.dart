import 'dart:convert';

import 'package:equatable/equatable.dart';

class GetSearchStudent extends Equatable {
	final bool? success;
	final String? message;
	final List<dynamic>? data;

	const GetSearchStudent({this.success, this.message, this.data});

	factory GetSearchStudent.fromMap(Map<String, dynamic> data) {
		return GetSearchStudent(
			success: data['success'] as bool?,
			message: data['message'] as String?,
			data: data['data'] as List<dynamic>?,
		);
	}



	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
				'data': data,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetSearchStudent].
	factory GetSearchStudent.fromJson(String data) {
		return GetSearchStudent.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [GetSearchStudent] to a JSON string.
	String toJson() => json.encode(toMap());

	GetSearchStudent copyWith({
		bool? success,
		String? message,
		List<dynamic>? data,
	}) {
		return GetSearchStudent(
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
