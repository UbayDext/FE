import 'dart:convert';

import 'package:equatable/equatable.dart';

class Ekskul extends Equatable {
	final int? id;
	final String? namaEkskul;
	final dynamic jumlahSiswa;
	final int? studiId;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Ekskul({
		this.id, 
		this.namaEkskul, 
		this.jumlahSiswa, 
		this.studiId, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory Ekskul.fromMap(Map<String, dynamic> data) => Ekskul(
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
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'nama_ekskul': namaEkskul,
				'jumlah_siswa': jumlahSiswa,
				'studi_id': studiId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Ekskul].
	factory Ekskul.fromJson(String data) {
		return Ekskul.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Ekskul] to a JSON string.
	String toJson() => json.encode(toMap());

	Ekskul copyWith({
		int? id,
		String? namaEkskul,
		dynamic jumlahSiswa,
		int? studiId,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Ekskul(
			id: id ?? this.id,
			namaEkskul: namaEkskul ?? this.namaEkskul,
			jumlahSiswa: jumlahSiswa ?? this.jumlahSiswa,
			studiId: studiId ?? this.studiId,
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
				namaEkskul,
				jumlahSiswa,
				studiId,
				createdAt,
				updatedAt,
		];
	}
}
