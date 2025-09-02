import 'dart:convert';

import 'package:equatable/equatable.dart';

class Data extends Equatable {
	final int? id;
	final String? title;
	final String? filePath;
	final String? fileUrl;
	final int? studentId;
	final dynamic studiId;
	final dynamic ekskulId;
	final dynamic classroomId;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Data({
		this.id, 
		this.title, 
		this.filePath, 
		this.fileUrl, 
		this.studentId, 
		this.studiId, 
		this.ekskulId, 
		this.classroomId, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				id: data['id'] as int?,
				title: data['title'] as String?,
				filePath: data['file_path'] as String?,
				fileUrl: data['file_url'] as String?,
				studentId: data['student_id'] as int?,
				studiId: data['studi_id'] as dynamic,
				ekskulId: data['ekskul_id'] as dynamic,
				classroomId: data['classroom_id'] as dynamic,
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'title': title,
				'file_path': filePath,
				'file_url': fileUrl,
				'student_id': studentId,
				'studi_id': studiId,
				'ekskul_id': ekskulId,
				'classroom_id': classroomId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
	factory Data.fromJson(String data) {
		return Data.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
	String toJson() => json.encode(toMap());

	Data copyWith({
		int? id,
		String? title,
		String? filePath,
		String? fileUrl,
		int? studentId,
		dynamic studiId,
		dynamic ekskulId,
		dynamic classroomId,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Data(
			id: id ?? this.id,
			title: title ?? this.title,
			filePath: filePath ?? this.filePath,
			fileUrl: fileUrl ?? this.fileUrl,
			studentId: studentId ?? this.studentId,
			studiId: studiId ?? this.studiId,
			ekskulId: ekskulId ?? this.ekskulId,
			classroomId: classroomId ?? this.classroomId,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				id,
				title,
				filePath,
				fileUrl,
				studentId,
				studiId,
				ekskulId,
				classroomId,
				createdAt,
				updatedAt,
		];
	}
}
