import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:planetbuku/EditBuku/models/book.dart';
import 'package:planetbuku/LihatBuku/screens/bookDetail.dart';

class ReviewFormPage extends StatefulWidget {
  final Book book;

  const ReviewFormPage({Key? key, required this.book}) : super(key: key);

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _review = "";
  int _rate = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String username = request.jsonData["username"];

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text(
          'Review ${widget.book.fields.title}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailPage(book: widget.book),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Write your review here",
                        labelText: "Review",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _review = value ?? "";
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Review cannot be empty!";
                        }
                        return null;
                      },
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Rate 0-5",
                        labelText: "Rate",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _rate = int.tryParse(value ?? "") ?? 0;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Rate cannot be empty!";
                        }
                        int? rate = int.tryParse(value);
                        if (rate == null || rate < 0 || rate > 5) {
                          return "Rate should be between 0 and 5!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Text(
                        'You are logged in as $username',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.pink),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await request.postJson(
                                "https://planetbuku.firdausfarul.repl.co/browse/give-review-flutter/${widget.book.pk}/",
                                jsonEncode(<String, dynamic>{
                                  'review': _review,
                                  'rate': _rate.toString(),
                                }),
                              );
                              if (response['status'] == 'success') {
                                if (!context.mounted) return;
                                if (response['existed']) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Center(
                                        child: Text(
                                          'Your review has been updated!',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: Colors.pink,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Center(
                                        child: Text(
                                          'Review added!',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: Colors.pink,
                                    ),
                                  );
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetailPage(book: widget.book),
                                  ),
                                );
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Something went wrong."),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
