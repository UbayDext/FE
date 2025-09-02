import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'datum.dart';

class GetCandidatPublic extends Equatable {
	final bool? success;
	final String? message;
	final List<Datum>? data;

	const GetCandidatPublic({this.success, this.message, this.data});

	factory GetCandidatPublic.fromMap(Map<String, dynamic> data) {
		return GetCandidatPublic(
			success: data['success'] as bool?,
			message: data['message'] as String?,
			data: (data['data'] as List<dynamic>?)
						?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
						.toList(),
		);
	}



	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
				'data': data?.map((e) => e.toMap()).toList(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetCandidatPublic].
	factory GetCandidatPublic.fromJson(String data) {
		return GetCandidatPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [GetCandidatPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	GetCandidatPublic copyWith({
		bool? success,
		String? message,
		List<Datum>? data,
	}) {
		return GetCandidatPublic(
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
