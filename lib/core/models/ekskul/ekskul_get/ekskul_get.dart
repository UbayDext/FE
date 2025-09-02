import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'studi.dart';

class EkskulGet extends Equatable {
	final int? id;
	final String? namaEkskul;
	final dynamic jumlahSiswa;
	final int? studiId;
	final DateTime? createdAt;
	final DateTime? updatedAt;
	final int? studentsCount;
	final Studi? studi;

	const EkskulGet({
		this.id, 
		this.namaEkskul, 
		this.jumlahSiswa, 
		this.studiId, 
		this.createdAt, 
		this.updatedAt, 
		this.studentsCount, 
		this.studi, 
	});

	factory EkskulGet.fromMap(Map<String, dynamic> data) => EkskulGet(
				id: data['id'] as int?,
				namaEkskul: data['nama_ekskul'] as String?,
				jumlahSiswa: data['jumlah_siswa'] as dynamic,
				studiId: data['studi_id'] as int?,
				createdAt: data['created_at'] == null
						? null
						: DateTime.parse(data['created_at'] as String),
				updatedAt: data['updated_at'] == null
						? null
						: DateTime.parse(data['updated_at'] as String),
				studentsCount: data['students_count'] as int?,
				studi: data['studi'] == null
						? null
						: Studi.fromMap(data['studi'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'nama_ekskul': namaEkskul,
				'jumlah_siswa': jumlahSiswa,
				'studi_id': studiId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
				'students_count': studentsCount,
				'studi': studi?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EkskulGet].
	factory EkskulGet.fromJson(String data) {
		return EkskulGet.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [EkskulGet] to a JSON string.
	String toJson() => json.encode(toMap());

	EkskulGet copyWith({
		int? id,
		String? namaEkskul,
		dynamic jumlahSiswa,
		int? studiId,
		DateTime? createdAt,
		DateTime? updatedAt,
		int? studentsCount,
		Studi? studi,
	}) {
		return EkskulGet(
			id: id ?? this.id,
			namaEkskul: namaEkskul ?? this.namaEkskul,
			jumlahSiswa: jumlahSiswa ?? this.jumlahSiswa,
			studiId: studiId ?? this.studiId,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
			studentsCount: studentsCount ?? this.studentsCount,
			studi: studi ?? this.studi,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				id,
				namaEkskul,
				jumlahSiswa,
				studiId,
				createdAt,
				updatedAt,
				studentsCount,
				studi,
		];
	}
}
