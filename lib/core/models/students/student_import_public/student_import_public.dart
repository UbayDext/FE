import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'failed.dart';
import 'imported.dart';

class StudentImportPublic extends Equatable {
	final String? status;
	final String? message;
	final List<Imported>? imported;
	final List<Failed>? failed;

	const StudentImportPublic({
		this.status, 
		this.message, 
		this.imported, 
		this.failed, 
	});

	factory StudentImportPublic.fromMap(Map<String, dynamic> data) {
		return StudentImportPublic(
			status: data['status'] as String?,
			message: data['message'] as String?,
			imported: (data['imported'] as List<dynamic>?)
						?.map((e) => Imported.fromMap(e as Map<String, dynamic>))
						.toList(),
			failed: (data['failed'] as List<dynamic>?)
						?.map((e) => Failed.fromMap(e as Map<String, dynamic>))
						.toList(),
		);
	}



	Map<String, dynamic> toMap() => {
				'status': status,
				'message': message,
				'imported': imported?.map((e) => e.toMap()).toList(),
				'failed': failed?.map((e) => e.toMap()).toList(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StudentImportPublic].
	factory StudentImportPublic.fromJson(String data) {
		return StudentImportPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [StudentImportPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	StudentImportPublic copyWith({
		String? status,
		String? message,
		List<Imported>? imported,
		List<Failed>? failed,
	}) {
		return StudentImportPublic(
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
