import 'dart:convert';

import 'package:equatable/equatable.dart';

class SertifikatDeleted extends Equatable {
	final String? message;

	const SertifikatDeleted({this.message});

	factory SertifikatDeleted.fromMap(Map<String, dynamic> data) {
		return SertifikatDeleted(
			message: data['message'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SertifikatDeleted].
	factory SertifikatDeleted.fromJson(String data) {
		return SertifikatDeleted.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [SertifikatDeleted] to a JSON string.
	String toJson() => json.encode(toMap());

	SertifikatDeleted copyWith({
		String? message,
	}) {
		return SertifikatDeleted(
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [message];
}
