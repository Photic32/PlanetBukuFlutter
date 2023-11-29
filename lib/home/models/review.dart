// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  String user;
  String review;
  int rate;
  DateTime reviewDate;

  Review({
    required this.user,
    required this.review,
    required this.rate,
    required this.reviewDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        user: json["user"],
        review: json["review"],
        rate: json["rate"],
        reviewDate: DateTime.parse(json["review_date"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "review": review,
        "rate": rate,
        "review_date":
            "${reviewDate.year.toString().padLeft(4, '0')}-${reviewDate.month.toString().padLeft(2, '0')}-${reviewDate.day.toString().padLeft(2, '0')}",
      };
}
