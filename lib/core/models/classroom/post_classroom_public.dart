import 'dart:convert';

import 'package:equatable/equatable.dart';

class PostClassroomPublic extends Equatable {
	final String? name;
	final int? studiId;
	final DateTime? updatedAt;
	final DateTime? createdAt;
	final int? id;

	const PostClassroomPublic({
		this.name, 
		this.studiId, 
		this.updatedAt, 
		this.createdAt, 
		this.id, 
	});

	factory PostClassroomPublic.fromMap(Map<String, dynamic> data) {
		return PostClassroomPublic(
			name: data['name'] as String?,
			studiId: data['studi_id'] as int?,
			updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
			createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
			id: data['id'] as int?,
		);
	}



	Map<String, dynamic> toMap() => {
				'name': name,
				'studi_id': studiId,
				'updated_at': updatedAt?.toIso8601String(),
				'created_at': createdAt?.toIso8601String(),
				'id': id,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PostClassroomPublic].
	factory PostClassroomPublic.fromJson(String data) {
		return PostClassroomPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [PostClassroomPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	PostClassroomPublic copyWith({
		String? name,
		int? studiId,
		DateTime? updatedAt,
		DateTime? createdAt,
		int? id,
	}) {
		return PostClassroomPublic(
			name: name ?? this.name,
			studiId: studiId ?? this.studiId,
			updatedAt: updatedAt ?? this.updatedAt,
			createdAt: createdAt ?? this.createdAt,
			id: id ?? this.id,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [name, studiId, updatedAt, createdAt, id];
}
