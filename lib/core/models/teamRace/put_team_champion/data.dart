import 'dart:convert';

import 'package:equatable/equatable.dart';

class Data extends Equatable {
	final int? id;
	final String? nameGroup;
	final String? nameTeam1;
	final String? nameTeam2;
	final String? nameTeam3;
	final String? nameTeam4;
	final String? nameTeam5;
	final int? lombadId;
	final String? champion;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Data({
		this.id, 
		this.nameGroup, 
		this.nameTeam1, 
		this.nameTeam2, 
		this.nameTeam3, 
		this.nameTeam4, 
		this.nameTeam5, 
		this.lombadId, 
		this.champion, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				id: data['id'] as int?,
				nameGroup: data['name_group'] as String?,
				nameTeam1: data['name_team1'] as String?,
				nameTeam2: data['name_team2'] as String?,
				nameTeam3: data['name_team3'] as String?,
				nameTeam4: data['name_team4'] as String?,
				nameTeam5: data['name_team5'] as String?,
				lombadId: data['lombad_id'] as int?,
				champion: data['champion'] as String?,
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name_group': nameGroup,
				'name_team1': nameTeam1,
				'name_team2': nameTeam2,
				'name_team3': nameTeam3,
				'name_team4': nameTeam4,
				'name_team5': nameTeam5,
				'lombad_id': lombadId,
				'champion': champion,
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
		String? nameGroup,
		String? nameTeam1,
		String? nameTeam2,
		String? nameTeam3,
		String? nameTeam4,
		String? nameTeam5,
		int? lombadId,
		String? champion,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Data(
			id: id ?? this.id,
			nameGroup: nameGroup ?? this.nameGroup,
			nameTeam1: nameTeam1 ?? this.nameTeam1,
			nameTeam2: nameTeam2 ?? this.nameTeam2,
			nameTeam3: nameTeam3 ?? this.nameTeam3,
			nameTeam4: nameTeam4 ?? this.nameTeam4,
			nameTeam5: nameTeam5 ?? this.nameTeam5,
			lombadId: lombadId ?? this.lombadId,
			champion: champion ?? this.champion,
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
				nameGroup,
				nameTeam1,
				nameTeam2,
				nameTeam3,
				nameTeam4,
				nameTeam5,
				lombadId,
				champion,
				createdAt,
				updatedAt,
		];
	}
}
