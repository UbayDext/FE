import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'data.dart';

class PostSertifikationPublic extends Equatable {
	final Data? data;

	const PostSertifikationPublic({this.data});

	factory PostSertifikationPublic.fromMap(Map<String, dynamic> data) {
		return PostSertifikationPublic(
			data: data['data'] == null
						? null
						: Data.fromMap(data['data'] as Map<String, dynamic>),
		);
	}



	Map<String, dynamic> toMap() => {
				'data': data?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PostSertifikationPublic].
	factory PostSertifikationPublic.fromJson(String data) {
		return PostSertifikationPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [PostSertifikationPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	PostSertifikationPublic copyWith({
		Data? data,
	}) {
		return PostSertifikationPublic(
			data: data ?? this.data,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [data];
}
