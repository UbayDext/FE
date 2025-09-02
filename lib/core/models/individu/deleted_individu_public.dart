import 'dart:convert';

import 'package:equatable/equatable.dart';

class DeletedIndividuPublic extends Equatable {
	final bool? success;
	final String? message;

	const DeletedIndividuPublic({this.success, this.message});

	factory DeletedIndividuPublic.fromMap(Map<String, dynamic> data) {
		return DeletedIndividuPublic(
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
  /// Parses the string and returns the resulting Json object as [DeletedIndividuPublic].
	factory DeletedIndividuPublic.fromJson(String data) {
		return DeletedIndividuPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [DeletedIndividuPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	DeletedIndividuPublic copyWith({
		bool? success,
		String? message,
	}) {
		return DeletedIndividuPublic(
			success: success ?? this.success,
			message: message ?? this.message,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message];
}
