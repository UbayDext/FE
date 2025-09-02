import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'data.dart';

class PutPoint extends Equatable {
	final bool? success;
	final String? message;
	final Data? data;

	const PutPoint({this.success, this.message, this.data});

	factory PutPoint.fromMap(Map<String, dynamic> data) => PutPoint(
				success: data['success'] as bool?,
				message: data['message'] as String?,
				data: data['data'] == null
						? null
						: Data.fromMap(data['data'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
				'data': data?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PutPoint].
	factory PutPoint.fromJson(String data) {
		return PutPoint.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [PutPoint] to a JSON string.
	String toJson() => json.encode(toMap());

	PutPoint copyWith({
		bool? success,
		String? message,
		Data? data,
	}) {
		return PutPoint(
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
