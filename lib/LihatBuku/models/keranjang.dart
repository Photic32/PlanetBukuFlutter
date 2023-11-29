// To parse this JSON data, do
//
//     final keranjang = keranjangFromJson(jsonString);

import 'dart:convert';

Keranjang keranjangFromJson(String str) => Keranjang.fromJson(json.decode(str));

String keranjangToJson(Keranjang data) => json.encode(data.toJson());

class Keranjang {
  String model;
  int pk;
  Fields fields;

  Keranjang({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Keranjang.fromJson(Map<String, dynamic> json) => Keranjang(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  int jumlahBuku;
  List<int> bookList;

  Fields({
    required this.user,
    required this.jumlahBuku,
    required this.bookList,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        jumlahBuku: json["jumlah_buku"],
        bookList: List<int>.from(json["book_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "jumlah_buku": jumlahBuku,
        "book_list": List<dynamic>.from(bookList.map((x) => x)),
      };
}
