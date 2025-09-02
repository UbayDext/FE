import 'dart:convert';

import 'package:equatable/equatable.dart';

class Data extends Equatable {
	final int? id;
	final String? username;
	final String? email;
	final dynamic role;

	const Data({this.id, this.username, this.email, this.role});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				id: data['id'] as int?,
				username: data['username'] as String?,
				email: data['email'] as String?,
				role: data['role'] as dynamic,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'username': username,
				'email': email,
				'role': role,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
	factory Data.fromJson(String data) {
		return Data.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
	String toJson() => json.encode(toMap());

	Data copyWith({
		int? id,
		String? username,
		String? email,
		dynamic role,
	}) {
		return Data(
			id: id ?? this.id,
			username: username ?? this.username,
			email: email ?? this.email,
			role: role ?? this.role,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, username, email, role];
}
