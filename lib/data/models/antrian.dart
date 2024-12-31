// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Antrian {
  int? id;
  final String nama;
  final String noAntrian;
  final bool isActive;
  Antrian({
    this.id,
    required this.nama,
    required this.noAntrian,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'noAntrian': noAntrian,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Antrian.fromMap(Map<String, dynamic> map) {
    return Antrian(
      id: map['id'] != null ? map['id'] as int : null,
      nama: map['nama'] as String,
      noAntrian: map['noAntrian'] as String,
      isActive: map['isActive'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory Antrian.fromJson(String source) =>
      Antrian.fromMap(json.decode(source) as Map<String, dynamic>);

  Antrian copyWith({
    int? id,
    String? nama,
    String? noAntrian,
    bool? isActive,
  }) {
    return Antrian(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      noAntrian: noAntrian ?? this.noAntrian,
      isActive: isActive ?? this.isActive,
    );
  }
}

var dataAntrian = [
  Antrian(nama: 'Teller', noAntrian: 'A-1', isActive: true),
  Antrian(nama: 'STNK', noAntrian: 'B-2', isActive: true),
  Antrian(nama: 'SIM', noAntrian: 'C-3', isActive: true),
  Antrian(nama: 'Customer Service', noAntrian: 'D-4', isActive: true),
];
