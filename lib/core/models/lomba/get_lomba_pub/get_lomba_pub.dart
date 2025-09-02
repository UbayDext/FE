import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'datum.dart';

class GetLombaPub extends Equatable {
	final bool? success;
	final String? message;
	final int? count;
	final List<Datum>? data;

	const GetLombaPub({this.success, this.message, this.count, this.data});

	factory GetLombaPub.fromMap(Map<String, dynamic> data) => GetLombaPub(
				success: data['success'] as bool?,
				message: data['message'] as String?,
				count: data['count'] as int?,
				data: (data['data'] as List<dynamic>?)
						?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
				'count': count,
				'data': data?.map((e) => e.toMap()).toList(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetLombaPub].
	factory GetLombaPub.fromJson(String data) {
		return GetLombaPub.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [GetLombaPub] to a JSON string.
	String toJson() => json.encode(toMap());

	GetLombaPub copyWith({
		bool? success,
		String? message,
		int? count,
		List<Datum>? data,
	}) {
		return GetLombaPub(
			success: success ?? this.success,
			message: message ?? this.message,
			count: count ?? this.count,
			data: data ?? this.data,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message, count, data];
}
