// To parse this JSON data, do
//
//     final bukuKesan = bukuKesanFromJson(jsonString);

import 'dart:convert';

BukuKesan bukuKesanFromJson(String str) => BukuKesan.fromJson(json.decode(str));

String bukuKesanToJson(BukuKesan data) => json.encode(data.toJson());

class BukuKesan {
  List<Dikembalikan> dipinjam;
  List<Dikembalikan> dikembalikan;

  BukuKesan({
    required this.dipinjam,
    required this.dikembalikan,
  });

  factory BukuKesan.fromJson(Map<String, dynamic> json) => BukuKesan(
        dipinjam: List<Dikembalikan>.from(
            json["dipinjam"].map((x) => Dikembalikan.fromJson(x))),
        dikembalikan: List<Dikembalikan>.from(
            json["dikembalikan"].map((x) => Dikembalikan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dipinjam": List<dynamic>.from(dipinjam.map((x) => x.toJson())),
        "dikembalikan": List<dynamic>.from(dikembalikan.map((x) => x.toJson())),
      };
}

class Dikembalikan {
  DateTime deadline;
  String status;
  String isbn;
  String title;
  String author;
  String image;
  int peminjamanId;
  int bookId;
  String kesan;

  Dikembalikan({
    required this.deadline,
    required this.status,
    required this.isbn,
    required this.title,
    required this.author,
    required this.image,
    required this.peminjamanId,
    required this.bookId,
    required this.kesan,
  });

  factory Dikembalikan.fromJson(Map<String, dynamic> json) => Dikembalikan(
        deadline: DateTime.parse(json["deadline"]),
        status: json["status"],
        isbn: json["isbn"],
        title: json["title"],
        author: json["author"],
        image: json["image"],
        peminjamanId: json["peminjaman_id"],
        bookId: json["book_id"],
        kesan: json["kesan"],
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
        "book_id": bookId,
        "kesan": kesan,
      };
}
