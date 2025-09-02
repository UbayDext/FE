import 'dart:convert';

import 'package:equatable/equatable.dart';

class Datum extends Equatable {
	final int? id;
	final String? nameLomba;
	final String? startDate;
	final String? endDate;
	final String? status;
	final String? statusRaw;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Datum({
		this.id, 
		this.nameLomba, 
		this.startDate, 
		this.endDate, 
		this.status, 
		this.statusRaw, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory Datum.fromMap(Map<String, dynamic> data) => Datum(
				id: data['id'] as int?,
				nameLomba: data['name_lomba'] as String?,
				startDate: data['start_date'] as String?,
				endDate: data['end_date'] as String?,
				status: data['status'] as String?,
				statusRaw: data['status_raw'] as String?,
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name_lomba': nameLomba,
				'start_date': startDate,
				'end_date': endDate,
				'status': status,
				'status_raw': statusRaw,
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
		String? nameLomba,
		String? startDate,
		String? endDate,
		String? status,
		String? statusRaw,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Datum(
			id: id ?? this.id,
			nameLomba: nameLomba ?? this.nameLomba,
			startDate: startDate ?? this.startDate,
			endDate: endDate ?? this.endDate,
			status: status ?? this.status,
			statusRaw: statusRaw ?? this.statusRaw,
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
				nameLomba,
				startDate,
				endDate,
				status,
				statusRaw,
				createdAt,
				updatedAt,
		];
	}
}
