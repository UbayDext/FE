import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'datum.dart';

class GetConfirmCandidat extends Equatable {
	final bool? success;
	final String? message;
	final List<Datum>? data;

	const GetConfirmCandidat({this.success, this.message, this.data});

	factory GetConfirmCandidat.fromMap(Map<String, dynamic> data) {
		return GetConfirmCandidat(
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
  /// Parses the string and returns the resulting Json object as [GetConfirmCandidat].
	factory GetConfirmCandidat.fromJson(String data) {
		return GetConfirmCandidat.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [GetConfirmCandidat] to a JSON string.
	String toJson() => json.encode(toMap());

	GetConfirmCandidat copyWith({
		bool? success,
		String? message,
		List<Datum>? data,
	}) {
		return GetConfirmCandidat(
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
