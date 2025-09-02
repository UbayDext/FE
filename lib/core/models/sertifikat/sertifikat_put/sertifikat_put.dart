import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'data.dart';

class SertifikatPut extends Equatable {
	final Data? data;

	const SertifikatPut({this.data});

	factory SertifikatPut.fromMap(Map<String, dynamic> data) => SertifikatPut(
				data: data['data'] == null
						? null
						: Data.fromMap(data['data'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'data': data?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SertifikatPut].
	factory SertifikatPut.fromJson(String data) {
		return SertifikatPut.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [SertifikatPut] to a JSON string.
	String toJson() => json.encode(toMap());

	SertifikatPut copyWith({
		Data? data,
	}) {
		return SertifikatPut(
			data: data ?? this.data,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [data];
}
