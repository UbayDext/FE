import 'dart:convert';

import 'package:equatable/equatable.dart';

class DeletedCandidat extends Equatable {
	final bool? success;
	final String? message;

	const DeletedCandidat({this.success, this.message});

	factory DeletedCandidat.fromMap(Map<String, dynamic> data) {
		return DeletedCandidat(
			success: data['success'] as bool?,
			message: data['message'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DeletedCandidat].
	factory DeletedCandidat.fromJson(String data) {
		return DeletedCandidat.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [DeletedCandidat] to a JSON string.
	String toJson() => json.encode(toMap());

	DeletedCandidat copyWith({
		bool? success,
		String? message,
	}) {
		return DeletedCandidat(
			success: success ?? this.success,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message];
}
