import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'data.dart';

class PutChampionPublic extends Equatable {
	final bool? success;
	final String? message;
	final Data? data;

	const PutChampionPublic({this.success, this.message, this.data});

	factory PutChampionPublic.fromMap(Map<String, dynamic> data) {
		return PutChampionPublic(
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
  /// Parses the string and returns the resulting Json object as [PutChampionPublic].
	factory PutChampionPublic.fromJson(String data) {
		return PutChampionPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [PutChampionPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	PutChampionPublic copyWith({
		bool? success,
		String? message,
		Data? data,
	}) {
		return PutChampionPublic(
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
