// To parse this JSON data, do
//
//     final peminjam = peminjamFromJson(jsonString);

import 'dart:convert';

Peminjam peminjamFromJson(String str) => Peminjam.fromJson(json.decode(str));

String peminjamToJson(Peminjam data) => json.encode(data.toJson());

class Peminjam {
  String username;
  int jumlahBukuDipinjam;
  List<BukuDipinjam> bukuDipinjam;

  Peminjam({
    required this.username,
    required this.jumlahBukuDipinjam,
    required this.bukuDipinjam,
  });

  factory Peminjam.fromJson(Map<String, dynamic> json) => Peminjam(
        username: json["username"],
        jumlahBukuDipinjam: json["jumlah_buku_dipinjam"],
        bukuDipinjam: List<BukuDipinjam>.from(
            json["buku_dipinjam"].map((x) => BukuDipinjam.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "jumlah_buku_dipinjam": jumlahBukuDipinjam,
        "buku_dipinjam":
            List<dynamic>.from(bukuDipinjam.map((x) => x.toJson())),
      };
}

class BukuDipinjam {
  DateTime deadline;
  String status;
  String isbn;
  String title;
  String author;
  String image;
  int peminjamanId;

  BukuDipinjam({
    required this.deadline,
    required this.status,
    required this.isbn,
    required this.title,
    required this.author,
    required this.image,
    required this.peminjamanId,
  });

  factory BukuDipinjam.fromJson(Map<String, dynamic> json) => BukuDipinjam(
        deadline: DateTime.parse(json["deadline"]),
        status: json["status"],
        isbn: json["isbn"],
        title: json["title"],
        author: json["author"],
        image: json["image"],
        peminjamanId: json["peminjaman_id"],
      );

  Map<String, dynamic> toJson() => {
        "deadline":
            "${deadline.year.toString().padLeft(4, '0')}-${deadline.month.toString().padLeft(2, '0')}-${deadline.day.toString().padLeft(2, '0')}",
        "status": status,
        "isbn": isbn,
        "title": title,
        "author": author,
        "image": image,
        "peminjaman_id": peminjamanId,
      };
}
