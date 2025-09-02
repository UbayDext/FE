import 'dart:convert';

import 'package:equatable/equatable.dart';

class RekapPublic extends Equatable {
	final int? h;
	final int? i;
	final int? s;
	final int? a;

	const RekapPublic({this.h, this.i, this.s, this.a});

	factory RekapPublic.fromMap(Map<String, dynamic> data) => RekapPublic(
				h: data['H'] as int?,
				i: data['I'] as int?,
				s: data['S'] as int?,
				a: data['A'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'H': h,
				'I': i,
				'S': s,
				'A': a,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RekapPublic].
	factory RekapPublic.fromJson(String data) {
		return RekapPublic.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [RekapPublic] to a JSON string.
	String toJson() => json.encode(toMap());

	RekapPublic copyWith({
		int? h,
		int? i,
		int? s,
		int? a,
	}) {
		return RekapPublic(
			h: h ?? this.h,
			i: i ?? this.i,
			s: s ?? this.s,
			a: a ?? this.a,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [h, i, s, a];
}
