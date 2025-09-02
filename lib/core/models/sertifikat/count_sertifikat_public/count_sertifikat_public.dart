import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'datum.dart';

class CountSertifikatPublic extends Equatable {
	final List<Datum>? data;

	const CountSertifikatPublic({this.data});

	factory CountSertifikatPublic.fromMap(Map<String, dynamic> data) {
		return CountSertifikatPublic(
			data: (data['data'] as List<dynamic>?)
						?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
						.toList(),
		);
	}



	Map<String, dynamic> toMap() => {
				'data': data?.map((e) => e.toMap()).toList(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CountSertifikatPublic].
	factory CountSertifikatPublic.fromJson(String data) {
		return CountSertifikatPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [CountSertifikatPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	CountSertifikatPublic copyWith({
		List<Datum>? data,
	}) {
		return CountSertifikatPublic(
			data: data ?? this.data,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [data];
}
