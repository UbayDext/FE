import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddMannyPublic extends Equatable {
	final String? status;
	final String? message;
	final List<int>? imported;
	final List<dynamic>? failed;

	const AddMannyPublic({
		this.status, 
		this.message, 
		this.imported, 
		this.failed, 
	});

	factory AddMannyPublic.fromMap(Map<String, dynamic> data) {
		return AddMannyPublic(
			status: data['status'] as String?,
			message: data['message'] as String?,
			imported: data['imported'] as List<int>?,
			failed: data['failed'] as List<dynamic>?,
		);
	}



	Map<String, dynamic> toMap() => {
				'status': status,
				'message': message,
				'imported': imported,
				'failed': failed,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AddMannyPublic].
	factory AddMannyPublic.fromJson(String data) {
		return AddMannyPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [AddMannyPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	AddMannyPublic copyWith({
		String? status,
		String? message,
		List<int>? imported,
		List<dynamic>? failed,
	}) {
		return AddMannyPublic(
			status: status ?? this.status,
			message: message ?? this.message,
			imported: imported ?? this.imported,
			failed: failed ?? this.failed,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [status, message, imported, failed];
}
