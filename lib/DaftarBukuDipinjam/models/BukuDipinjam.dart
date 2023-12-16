// To parse this JSON data, do
//
//     final dipinjam = dipinjamFromJson(jsonString);

import 'dart:convert';

List<Dipinjam> dipinjamFromJson(String str) => List<Dipinjam>.from(json.decode(str).map((x) => Dipinjam.fromJson(x)));

String dipinjamToJson(List<Dipinjam> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Dipinjam {
    String model;
    int pk;
    Fields fields;

    Dipinjam({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Dipinjam.fromJson(Map<String, dynamic> json) => Dipinjam(
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
    int pengguna;
    DateTime tanggalPeminjaman;
    DateTime tanggalPengembalian;
    int buku;
    String status;

    Fields({
        required this.pengguna,
        required this.tanggalPeminjaman,
        required this.tanggalPengembalian,
        required this.buku,
        required this.status,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        pengguna: json["pengguna"],
        tanggalPeminjaman: DateTime.parse(json["tanggal_peminjaman"]),
        tanggalPengembalian: DateTime.parse(json["tanggal_pengembalian"]),
        buku: json["buku"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "pengguna": pengguna,
        "tanggal_peminjaman": "${tanggalPeminjaman.year.toString().padLeft(4, '0')}-${tanggalPeminjaman.month.toString().padLeft(2, '0')}-${tanggalPeminjaman.day.toString().padLeft(2, '0')}",
        "tanggal_pengembalian": "${tanggalPengembalian.year.toString().padLeft(4, '0')}-${tanggalPengembalian.month.toString().padLeft(2, '0')}-${tanggalPengembalian.day.toString().padLeft(2, '0')}",
        "buku": buku,
        "status": status,
    };
}
