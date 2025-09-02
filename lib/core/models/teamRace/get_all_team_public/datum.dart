import 'dart:convert';

import 'package:equatable/equatable.dart';

class Datum extends Equatable {
	final int? id;
	final String? nameGroup;
	final String? nameTeam1;
	final String? nameTeam2;
	final String? nameTeam3;
	final String? nameTeam4;
	final int? lombadId;
	final String? winnerMatch1;
	final String? winnerMatch2;
	final String? champion;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Datum({
		this.id, 
		this.nameGroup, 
		this.nameTeam1, 
		this.nameTeam2, 
		this.nameTeam3, 
		this.nameTeam4, 
		this.lombadId, 
		this.winnerMatch1, 
		this.winnerMatch2, 
		this.champion, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory Datum.fromMap(Map<String, dynamic> data) => Datum(
				id: data['id'] as int?,
				nameGroup: data['name_group'] as String?,
				nameTeam1: data['name_team1'] as String?,
				nameTeam2: data['name_team2'] as String?,
				nameTeam3: data['name_team3'] as String?,
				nameTeam4: data['name_team4'] as String?,
				lombadId: data['lombad_id'] as int?,
				winnerMatch1: data['winner_match1'] as String?,
				winnerMatch2: data['winner_match2'] as String?,
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
				'lombad_id': lombadId,
				'winner_match1': winnerMatch1,
				'winner_match2': winnerMatch2,
				'champion': champion,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
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
		int? id,
		String? nameGroup,
		String? nameTeam1,
		String? nameTeam2,
		String? nameTeam3,
		String? nameTeam4,
		int? lombadId,
		String? winnerMatch1,
		String? winnerMatch2,
		String? champion,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Datum(
			id: id ?? this.id,
			nameGroup: nameGroup ?? this.nameGroup,
			nameTeam1: nameTeam1 ?? this.nameTeam1,
			nameTeam2: nameTeam2 ?? this.nameTeam2,
			nameTeam3: nameTeam3 ?? this.nameTeam3,
			nameTeam4: nameTeam4 ?? this.nameTeam4,
			lombadId: lombadId ?? this.lombadId,
			winnerMatch1: winnerMatch1 ?? this.winnerMatch1,
			winnerMatch2: winnerMatch2 ?? this.winnerMatch2,
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
				lombadId,
				winnerMatch1,
				winnerMatch2,
				champion,
				createdAt,
				updatedAt,
		];
	}
}
