import 'dart:convert';

import 'package:equatable/equatable.dart';

class Data extends Equatable {
	final String? nameGroup;
	final String? nameTeam1;
	final String? nameTeam2;
	final String? nameTeam3;
	final String? nameTeam4;
	final int? lombadId;
	final DateTime? updatedAt;
	final DateTime? createdAt;
	final int? id;

	const Data({
		this.nameGroup, 
		this.nameTeam1, 
		this.nameTeam2, 
		this.nameTeam3, 
		this.nameTeam4, 
		this.lombadId, 
		this.updatedAt, 
		this.createdAt, 
		this.id, 
	});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				nameGroup: data['name_group'] as String?,
				nameTeam1: data['name_team1'] as String?,
				nameTeam2: data['name_team2'] as String?,
				nameTeam3: data['name_team3'] as String?,
				nameTeam4: data['name_team4'] as String?,
				lombadId: data['lombad_id'] as int?,
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				id: data['id'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'name_group': nameGroup,
				'name_team1': nameTeam1,
				'name_team2': nameTeam2,
				'name_team3': nameTeam3,
				'name_team4': nameTeam4,
				'lombad_id': lombadId,
				'updated_at': updatedAt?.toIso8601String(),
				'created_at': createdAt?.toIso8601String(),
				'id': id,
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
		String? nameGroup,
		String? nameTeam1,
		String? nameTeam2,
		String? nameTeam3,
		String? nameTeam4,
		int? lombadId,
		DateTime? updatedAt,
		DateTime? createdAt,
		int? id,
	}) {
		return Data(
			nameGroup: nameGroup ?? this.nameGroup,
			nameTeam1: nameTeam1 ?? this.nameTeam1,
			nameTeam2: nameTeam2 ?? this.nameTeam2,
			nameTeam3: nameTeam3 ?? this.nameTeam3,
			nameTeam4: nameTeam4 ?? this.nameTeam4,
			lombadId: lombadId ?? this.lombadId,
			updatedAt: updatedAt ?? this.updatedAt,
			createdAt: createdAt ?? this.createdAt,
			id: id ?? this.id,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				nameGroup,
				nameTeam1,
				nameTeam2,
				nameTeam3,
				nameTeam4,
				lombadId,
				updatedAt,
				createdAt,
				id,
		];
	}
}
