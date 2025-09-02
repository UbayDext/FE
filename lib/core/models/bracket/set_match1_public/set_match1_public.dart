import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'data.dart';

class SetMatch1Public extends Equatable {
	final bool? success;
	final String? message;
	final Data? data;

	const SetMatch1Public({this.success, this.message, this.data});

	factory SetMatch1Public.fromMap(Map<String, dynamic> data) {
		return SetMatch1Public(
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
  /// Parses the string and returns the resulting Json object as [SetMatch1Public].
	factory SetMatch1Public.fromJson(String data) {
		return SetMatch1Public.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [SetMatch1Public] to a JSON string.
	String toJson() => json.encode(toMap());

	SetMatch1Public copyWith({
		bool? success,
		String? message,
		Data? data,
	}) {
		return SetMatch1Public(
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
