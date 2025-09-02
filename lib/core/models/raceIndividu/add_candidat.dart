import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddCandidat extends Equatable {
	final bool? success;
	final String? message;

	const AddCandidat({this.success, this.message});

	factory AddCandidat.fromMap(Map<String, dynamic> data) => AddCandidat(
				success: data['success'] as bool?,
				message: data['message'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AddCandidat].
	factory AddCandidat.fromJson(String data) {
		return AddCandidat.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [AddCandidat] to a JSON string.
	String toJson() => json.encode(toMap());

	AddCandidat copyWith({
		bool? success,
		String? message,
	}) {
		return AddCandidat(
			success: success ?? this.success,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message];
}
