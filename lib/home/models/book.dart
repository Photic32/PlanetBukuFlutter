// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  String model;
  int pk;
  Fields fields;

  Book({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
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
  String isbn;
  String title;
  String author;
  int publicationYear;
  String publisher;
  String imageS;
  String imageM;
  String imageL;
  int stock;

  Fields({
    required this.isbn,
    required this.title,
    required this.author,
    required this.publicationYear,
    required this.publisher,
    required this.imageS,
    required this.imageM,
    required this.imageL,
    required this.stock,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        isbn: json["isbn"],
        title: json["title"],
        author: json["author"],
        publicationYear: json["publication_year"],
        publisher: json["publisher"],
        imageS: json["image_s"],
        imageM: json["image_m"],
        imageL: json["image_l"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "title": title,
        "author": author,
        "publication_year": publicationYear,
        "publisher": publisher,
        "image_s": imageS,
        "image_m": imageM,
        "image_l": imageL,
        "stock": stock,
      };
}
