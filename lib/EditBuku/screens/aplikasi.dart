import 'package:flutter/material.dart';
import 'package:planetbuku/EditBuku/screens/book_form.dart';
import 'package:planetbuku/EditBuku/screens/editBook_form.dart';
import 'package:planetbuku/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:planetbuku/EditBuku/models/book.dart';

class EditBuku extends StatefulWidget {
  const EditBuku({Key? key}) : super(key: key);

  @override
  _EditBukuState createState() => _EditBukuState();
}

class _EditBukuState extends State<EditBuku> {
  Future<List<Book>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse('http://127.0.0.1:8000/adminbook/get_books_json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/get_books_json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> list_books = [];
    for (var d in data) {
      if (d != null) {
        list_books.add(Book.fromJson(d));
      }
    }
    return list_books;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Edit Informasi Buku'),
        backgroundColor: Colors.pink,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Tidak ada data buku.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman EditBookPage dengan membawa data buku
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBookPage(item: snapshot.data![index]),
                      ),
                    );
                  },
                  child: Container(
                    color: const Color.fromARGB(255, 124, 124, 124),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Row( // Menggunakan Row untuk menyusun gambar dan teks secara horizontal
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar
                        Image.network(
                          "${snapshot.data![index].fields.imageL}",
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16), // Memberi jarak antara gambar dan teks
                        // Informasi Buku
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data![index].fields.title}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Stock : ${snapshot.data![index].fields.stock}"),
                              const SizedBox(height: 10),
                              Text("Penulis : ${snapshot.data![index].fields.author}")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman BookFormPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BookFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
