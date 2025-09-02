import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'datum.dart';
import 'links.dart';
import 'meta.dart';

class SertifikationsGetPublic extends Equatable {
	final List<Datum>? data;
	final Links? links;
	final Meta? meta;

	const SertifikationsGetPublic({this.data, this.links, this.meta});

	factory SertifikationsGetPublic.fromMap(Map<String, dynamic> data) {
		return SertifikationsGetPublic(
			data: (data['data'] as List<dynamic>?)
						?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
						.toList(),
			links: data['links'] == null
						? null
						: Links.fromMap(data['links'] as Map<String, dynamic>),
			meta: data['meta'] == null
						? null
						: Meta.fromMap(data['meta'] as Map<String, dynamic>),
		);
	}



	Map<String, dynamic> toMap() => {
				'data': data?.map((e) => e.toMap()).toList(),
				'links': links?.toMap(),
				'meta': meta?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SertifikationsGetPublic].
	factory SertifikationsGetPublic.fromJson(String data) {
		return SertifikationsGetPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [SertifikationsGetPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	SertifikationsGetPublic copyWith({
		List<Datum>? data,
		Links? links,
		Meta? meta,
	}) {
		return SertifikationsGetPublic(
			data: data ?? this.data,
			links: links ?? this.links,
			meta: meta ?? this.meta,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [data, links, meta];
}
