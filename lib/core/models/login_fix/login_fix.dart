import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'user.dart';

class LoginFix extends Equatable {
	final User? user;
	final String? token;

	const LoginFix({this.user, this.token});

	factory LoginFix.fromMap(Map<String, dynamic> data) => LoginFix(
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
  /// Parses the string and returns the resulting Json object as [LoginFix].
	factory LoginFix.fromJson(String data) {
		return LoginFix.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [LoginFix] to a JSON string.
	String toJson() => json.encode(toMap());

	LoginFix copyWith({
		User? user,
		String? token,
	}) {
		return LoginFix(
			user: user ?? this.user,
			token: token ?? this.token,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [user, token];
}
