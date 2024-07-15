// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Income {
  final int? id;
  final String? periodeTanggal;
  final String? type;
  final int quantity;
  final int hargaSatuan;
  final int amount;
  final String title;
  final String? deskripsi;
  Income({
    this.id,
    this.periodeTanggal,
    this.type,
    required this.quantity,
    required this.hargaSatuan,
    required this.amount,
    required this.title,
    this.deskripsi,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'periode_tanggal': periodeTanggal,
      'type': type,
      'quantity': quantity,
      'harga_satuan': hargaSatuan,
      'amount': amount,
      'title': title,
      'deskripsi': deskripsi,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'] != null ? map['id'] as int : null,
      periodeTanggal: map['periode_tanggal'] != null ? map['periode_tanggal'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      quantity: map['quantity'] as int,
      hargaSatuan: map['harga_satuan'] as int,
      amount: map['amount'] as int,
      title: map['title'] as String,
      deskripsi: map['deskripsi'] != null ? map['deskripsi'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Income.fromJson(String source) => Income.fromMap(json.decode(source) as Map<String, dynamic>);
}
