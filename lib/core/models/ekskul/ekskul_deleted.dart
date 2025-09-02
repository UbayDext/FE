import 'dart:convert';

import 'package:equatable/equatable.dart';

class EkskulDeleted extends Equatable {
	final String? message;

	const EkskulDeleted({this.message});

	factory EkskulDeleted.fromMap(Map<String, dynamic> data) => EkskulDeleted(
				message: data['message'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EkskulDeleted].
	factory EkskulDeleted.fromJson(String data) {
		return EkskulDeleted.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [EkskulDeleted] to a JSON string.
	String toJson() => json.encode(toMap());

	EkskulDeleted copyWith({
		String? message,
	}) {
		return EkskulDeleted(
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [message];
}
