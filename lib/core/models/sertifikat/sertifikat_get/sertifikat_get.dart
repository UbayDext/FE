// import 'dart:convert';

// import 'package:equatable/equatable.dart';

// import 'datum.dart';

// class SertifikatGet extends Equatable {
// 	final List<Datum>? data;

// 	const SertifikatGet({this.data});

// 	factory SertifikatGet.fromMap(Map<String, dynamic> data) => SertifikatGet(
// 				data: (data['data'] as List<dynamic>?)
// 						?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
// 						.toList(),
// 			);

// 	Map<String, dynamic> toMap() => {
// 				'data': data?.map((e) => e.toMap()).toList(),
// 			};

//   /// `dart:convert`
//   ///
//   /// Parses the string and returns the resulting Json object as [SertifikatGet].
// 	factory SertifikatGet.fromJson(String data) {
// 		return SertifikatGet.fromMap(json.decode(data) as Map<String, dynamic>);
// 	}
//   /// `dart:convert`
//   ///
//   /// Converts [SertifikatGet] to a JSON string.
// 	String toJson() => json.encode(toMap());

// 	SertifikatGet copyWith({
// 		List<Datum>? data,
// 	}) {
// 		return SertifikatGet(
// 			data: data ?? this.data,
// 		);
// 	}

// 	@override
// 	bool get stringify => true;

// 	@override
// 	List<Object?> get props => [data];
// }
