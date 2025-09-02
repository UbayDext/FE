import 'dart:convert';

import 'package:equatable/equatable.dart';

class Data extends Equatable {
	final int? id;
	final String? nameLomba;
	final int? ekskulId;
	final String? startDate;
	final String? endDate;
	final String? status;
	final int? lombadId;

	const Data({
		this.id, 
		this.nameLomba, 
		this.ekskulId, 
		this.startDate, 
		this.endDate, 
		this.status, 
		this.lombadId, 
	});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				id: data['id'] as int?,
				nameLomba: data['name_lomba'] as String?,
				ekskulId: data['ekskul_id'] as int?,
				startDate: data['start_date'] as String?,
				endDate: data['end_date'] as String?,
				status: data['status'] as String?,
				lombadId: data['lombad_id'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name_lomba': nameLomba,
				'ekskul_id': ekskulId,
				'start_date': startDate,
				'end_date': endDate,
				'status': status,
				'lombad_id': lombadId,
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
		String? nameLomba,
		int? ekskulId,
		String? startDate,
		String? endDate,
		String? status,
		int? lombadId,
	}) {
		return Data(
			id: id ?? this.id,
			nameLomba: nameLomba ?? this.nameLomba,
			ekskulId: ekskulId ?? this.ekskulId,
			startDate: startDate ?? this.startDate,
			endDate: endDate ?? this.endDate,
			status: status ?? this.status,
			lombadId: lombadId ?? this.lombadId,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				id,
				nameLomba,
				ekskulId,
				startDate,
				endDate,
				status,
				lombadId,
		];
	}
}
