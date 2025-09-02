import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'user.dart';

class LoginPublic extends Equatable {
	final User? user;
	final String? token;

	const LoginPublic({this.user, this.token});

	factory LoginPublic.fromMap(Map<String, dynamic> data) => LoginPublic(
				user: data['user'] == null
						? null
						: User.fromMap(data['user'] as Map<String, dynamic>),
				token: data['token'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'user': user?.toMap(),
				'token': token,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginPublic].
	factory LoginPublic.fromJson(String data) {
		return LoginPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [LoginPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	LoginPublic copyWith({
		User? user,
		String? token,
	}) {
		return LoginPublic(
			user: user ?? this.user,
			token: token ?? this.token,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [user, token];
}
