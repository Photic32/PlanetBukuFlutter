import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planetbuku/drawer.dart';
import 'package:planetbuku/EditBuku/models/book.dart';
import 'package:planetbuku/LihatBuku/screens/bookDetail.dart';
import 'package:planetbuku/LihatBuku/widgets/customBookListItem.dart';

class LihatBuku extends StatefulWidget {
  const LihatBuku({super.key});

  @override
  LihatBukuState createState() => LihatBukuState();
}

class LihatBukuState extends State<LihatBuku> {
  bool _isLoading = false;
  List<Book> _foundBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _foundBooks = await fetchBooks();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse(
        'https://planetbuku1.firdausfarul.repl.co/adminbook/get_books_json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      List<Book> books = [];
      for (var d in data) {
        if (d != null) {
          books.add(Book.fromJson(d));
        }
      }
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  void _runFilter(String enteredKeyword) async {
    List<Book> results = [];
    List<Book> allBooks = await fetchBooks();

    if (enteredKeyword.isEmpty) {
      results = allBooks;
    } else {
      results = allBooks
          .where((book) => book.fields.title.toLowerCase().contains(
                enteredKeyword.toLowerCase(),
              ))
          .toList();
    }

    setState(() {
      _foundBooks = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Books',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[850],
        drawer: const LeftDrawer(),
        appBar: AppBar(
          title: const Text(
            'Discover New Books',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.pink,
        ),
        body: Column(
          children: [
            SearchAnchor(
              isFullScreen: false,
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return const Iterable.empty();
              },
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: (value) => _runFilter(value),
                  leading: const Icon(Icons.search),
                );
              },
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _foundBooks.isEmpty
                      ? const Column(
                          children: [
                            Text(
                              "No books matching",
                              style:
                                  TextStyle(color: Colors.pink, fontSize: 20),
                            ),
                            SizedBox(height: 8),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _foundBooks.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: Colors.grey[800],
                              height: 1,
                            );
                          },
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailPage(book: _foundBooks[index]),
                                ),
                              );
                            },
                            child: CustomBookListItem(
                              title: _foundBooks[index].fields.title,
                              author: _foundBooks[index].fields.author,
                              publicationYear:
                                  _foundBooks[index].fields.publicationYear,
                              stock: _foundBooks[index].fields.stock,
                              thumbnailUrl: _foundBooks[index].fields.imageL,
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
