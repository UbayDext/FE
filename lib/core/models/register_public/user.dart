import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
	final String? name;
	final String? email;
	final DateTime? updatedAt;
	final DateTime? createdAt;
	final int? id;

	const User({
		this.name, 
		this.email, 
		this.updatedAt, 
		this.createdAt, 
		this.id, 
	});

	factory User.fromMap(Map<String, dynamic> data) => User(
				name: data['name'] as String?,
				email: data['email'] as String?,
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				id: data['id'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'name': name,
				'email': email,
				'updated_at': updatedAt?.toIso8601String(),
				'created_at': createdAt?.toIso8601String(),
				'id': id,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
	factory User.fromJson(String data) {
		return User.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
	String toJson() => json.encode(toMap());

	User copyWith({
		String? name,
		String? email,
		DateTime? updatedAt,
		DateTime? createdAt,
		int? id,
	}) {
		return User(
			name: name ?? this.name,
			email: email ?? this.email,
			updatedAt: updatedAt ?? this.updatedAt,
			createdAt: createdAt ?? this.createdAt,
			id: id ?? this.id,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [name, email, updatedAt, createdAt, id];
}
