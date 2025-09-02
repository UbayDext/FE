import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'datum.dart';

class GetClassroomStudentNew extends Equatable {
	final bool? success;
	final String? message;
	final List<Datum>? data;

	const GetClassroomStudentNew({this.success, this.message, this.data});

	factory GetClassroomStudentNew.fromMap(Map<String, dynamic> data) {
		return GetClassroomStudentNew(
			success: data['success'] as bool?,
			message: data['message'] as String?,
			data: (data['data'] as List<dynamic>?)
						?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
						.toList(),
		);
	}



	Map<String, dynamic> toMap() => {
				'success': success,
				'message': message,
				'data': data?.map((e) => e.toMap()).toList(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetClassroomStudentNew].
	factory GetClassroomStudentNew.fromJson(String data) {
		return GetClassroomStudentNew.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [GetClassroomStudentNew] to a JSON string.
	String toJson() => json.encode(toMap());

	GetClassroomStudentNew copyWith({
		bool? success,
		String? message,
		List<Datum>? data,
	}) {
		return GetClassroomStudentNew(
			success: success ?? this.success,
			message: message ?? this.message,
			data: data ?? this.data,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [success, message, data];
}
