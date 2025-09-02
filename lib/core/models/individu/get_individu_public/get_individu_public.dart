import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'datum.dart';

class GetIndividuPublic extends Equatable {
	final bool? success;
	final String? message;
	final List<Datum>? data;

	const GetIndividuPublic({this.success, this.message, this.data});

	factory GetIndividuPublic.fromMap(Map<String, dynamic> data) {
		return GetIndividuPublic(
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
  /// Parses the string and returns the resulting Json object as [GetIndividuPublic].
	factory GetIndividuPublic.fromJson(String data) {
		return GetIndividuPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [GetIndividuPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	GetIndividuPublic copyWith({
		bool? success,
		String? message,
		List<Datum>? data,
	}) {
		return GetIndividuPublic(
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
