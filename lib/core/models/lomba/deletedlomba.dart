import 'dart:convert';

import 'package:equatable/equatable.dart';

class Deletedlomba extends Equatable {
	final String? message;

	const Deletedlomba({this.message});

	factory Deletedlomba.fromMap(Map<String, dynamic> data) => Deletedlomba(
				message: data['message'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Deletedlomba].
	factory Deletedlomba.fromJson(String data) {
		return Deletedlomba.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Deletedlomba] to a JSON string.
	String toJson() => json.encode(toMap());

	Deletedlomba copyWith({
		String? message,
	}) {
		return Deletedlomba(
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [message];
}
