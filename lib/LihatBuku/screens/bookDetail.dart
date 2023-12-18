import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:planetbuku/EditBuku/models/book.dart';
import 'package:planetbuku/LihatBuku/models/review.dart';
import 'package:planetbuku/LihatBuku/screens/reviewForm.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  BookDetailPageState createState() => BookDetailPageState();
}

class BookDetailPageState extends State<BookDetailPage> {
  Future<List<Review>> fetchReview() async {
    var url = Uri.parse(
        'https://planetbuku1.firdausfarul.repl.co/browse/get-review-json/${widget.book.pk}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      var data = jsonResponse['reviews']; // Access 'reviews' key

      List<Review> reviews = [];
      for (var d in data) {
        if (d != null) {
          reviews.add(Review.fromJson(d));
        }
      }
      return reviews;
    } else {
      throw Exception('Failed to load reviews'); // Updated error message
    }
  }

  Future<void> addToCart(BuildContext context, String bookId) async {
    final request = context.read<CookieRequest>();
    try {
      var response = await request.get('https://planetbuku1.firdausfarul.repl.co/browse/add-to-cart-flutter/$bookId/');
      if (response != null && response["status"]) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Successfully added to cart!',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Colors.pink,
          ),
        );
        setState(() {});
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'You have added this book to cart!',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Colors.pink,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to add to cart',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pink,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 150,
                  child: Image.network(
                    widget.book.fields.imageL,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.fields.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.book.fields.author,
                        style: const TextStyle(
                            color: Colors.pink, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text('ISBN: ${widget.book.fields.isbn}'),
                      const SizedBox(height: 5),
                      Text('Publisher: ${widget.book.fields.publisher}'),
                      const SizedBox(height: 5),
                      Text(
                          'Publication Year: ${widget.book.fields.publicationYear}'),
                      const SizedBox(height: 5),
                      Text('Stock: ${widget.book.fields.stock}'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 120,
              height: 36,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: widget.book.fields.stock > 0
                      ? Colors.pink
                      : Colors.grey[800],
                ),
                onPressed: widget.book.fields.stock > 0
                    ? () async {
                  if (request.loggedIn) {
                    addToCart(context, widget.book.pk.toString());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(
                          child: Text(
                            'Please log in first',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        backgroundColor: Colors.pink,
                      ),
                    );
                  }
                }
                    : null,
                child: Text(
                  widget.book.fields.stock > 0 ? 'Add to cart' : 'No Stock',
                  style: TextStyle(
                    color: widget.book.fields.stock > 0
                        ? const Color(0xffffffff)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'User Reviews',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.pink),
                    ),
                    onPressed: () {
                      if (request.loggedIn) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReviewFormPage(book: widget.book),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text(
                                'Please log in first',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            backgroundColor: Colors.pink,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Review",
                      style: TextStyle(
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: FutureBuilder(
              future: fetchReview(),
              builder: (context, AsyncSnapshot<List<Review>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Center(
                          child: Text(
                            "No reviews yet! Be the first",
                            style: TextStyle(color: Colors.pink, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.grey[800],
                        height: 1,
                      );
                    },
                    itemBuilder: (_, index) => InkWell(
                      child: ListTile(
                          isThreeLine: true,
                          leading: CircleAvatar(
                            child: Text(
                              snapshot.data![index].user.isNotEmpty
                                  ? snapshot.data![index].user[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(
                            snapshot.data![index].user,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            snapshot.data![index].reviewDate),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 60),
                                  Expanded(
                                    child:
                                    Text("${snapshot.data![index].rate}/5",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.pink[100],
                                          backgroundColor: Colors.pink[900],
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(snapshot.data![index].review),
                            ],
                          )),
                    ),
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
