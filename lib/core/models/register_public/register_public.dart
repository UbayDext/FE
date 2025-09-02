import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'user.dart';

class RegisterPublic extends Equatable {
	final User? user;
	final String? token;

	const RegisterPublic({this.user, this.token});

	factory RegisterPublic.fromMap(Map<String, dynamic> data) {
		return RegisterPublic(
			user: data['user'] == null
						? null
						: User.fromMap(data['user'] as Map<String, dynamic>),
			token: data['token'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'user': user?.toMap(),
				'token': token,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RegisterPublic].
	factory RegisterPublic.fromJson(String data) {
		return RegisterPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [RegisterPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	RegisterPublic copyWith({
		User? user,
		String? token,
	}) {
		return RegisterPublic(
			user: user ?? this.user,
			token: token ?? this.token,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [user, token];
}
