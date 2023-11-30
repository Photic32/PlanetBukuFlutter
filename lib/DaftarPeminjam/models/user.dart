// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String username;
  int userId;
  int jumlahBukuDipinjam;
  int denda;

  User({
    required this.username,
    required this.userId,
    required this.jumlahBukuDipinjam,
    required this.denda,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        userId: json["user_id"],
        jumlahBukuDipinjam: json["jumlah_buku_dipinjam"],
        denda: json["denda"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "user_id": userId,
        "jumlah_buku_dipinjam": jumlahBukuDipinjam,
        "denda": denda,
      };
}
