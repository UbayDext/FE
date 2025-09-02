import 'dart:convert';

import 'package:equatable/equatable.dart';

class Datum extends Equatable {
	final int? studentId;
	final String? total;
	final dynamic fileUrl;

	const Datum({this.studentId, this.total, this.fileUrl});

	factory Datum.fromMap(Map<String, dynamic> data) => Datum(
				studentId: data['student_id'] as int?,
				total: data['total'] as String?,
				fileUrl: data['file_url'] as dynamic,
			);

	Map<String, dynamic> toMap() => {
				'student_id': studentId,
				'total': total,
				'file_url': fileUrl,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
	factory Datum.fromJson(String data) {
		return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
	String toJson() => json.encode(toMap());

	Datum copyWith({
		int? studentId,
		String? total,
		dynamic fileUrl,
	}) {
		return Datum(
			studentId: studentId ?? this.studentId,
			total: total ?? this.total,
			fileUrl: fileUrl ?? this.fileUrl,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [studentId, total, fileUrl];
}
