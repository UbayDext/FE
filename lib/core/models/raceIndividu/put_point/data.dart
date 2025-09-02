import 'dart:convert';

import 'package:equatable/equatable.dart';

class Data extends Equatable {
	final int? id;
	final int? total;

	const Data({this.id, this.total});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				id: data['id'] as int?,
				total: data['total'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'total': total,
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
		int? total,
	}) {
		return Data(
			id: id ?? this.id,
			total: total ?? this.total,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, total];
}
