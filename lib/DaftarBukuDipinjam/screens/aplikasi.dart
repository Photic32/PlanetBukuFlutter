import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:planetbuku/DaftarBukuDipinjam/models/BukuKesan.dart';
import 'package:planetbuku/DaftarBukuDipinjam/screens/kesanForm.dart';
import 'package:planetbuku/DaftarPeminjam/models/peminjam.dart';
import 'package:planetbuku/DaftarPeminjam/models/user.dart';
import 'package:planetbuku/EditBuku/models/book.dart';
import 'package:planetbuku/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:planetbuku/DaftarBukuDipinjam/models/BukuDipinjam.dart';

class DaftarBukuDipinjam extends StatefulWidget {
  const DaftarBukuDipinjam({Key? key}) : super(key: key);
  @override
  _DaftarBukuDipinjamState createState() => _DaftarBukuDipinjamState();
}

class _DaftarBukuDipinjamState extends State<DaftarBukuDipinjam> {
  @override
  void initState() {
    super.initState();
  }

  Future<BukuKesan> fetchProduct() async {
    final request = context.watch<CookieRequest>();
    Map<String, dynamic> jsonData = request.getJsonData();

    int idUser = jsonData["user_id"];

    var response = await http.get(Uri.parse(
        'https://planetbuku1.firdausfarul.repl.co/borrowed_book_list/borrowed-book-byid/$idUser'));

    final data = jsonDecode(utf8.decode(response.bodyBytes));

    BukuKesan buku = BukuKesan.fromJson(data);
    return buku;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: const Text(
            'Buku Dipinjam dan Dikembalikan',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
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
                        "Tidak ada buku yang dipinjam",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Text(
                        'Buku yang Dipinjam',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.dipinjam.length,
                            itemBuilder: (BuildContext, int index) {
                              if (true) {
                                return Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Align the children in the center vertically
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // Align the children in the center horizontally
                                    children: [
                                      Image.network(
                                          snapshot.data!.dipinjam[index].image),
                                      ListTile(
                                        title: Text(
                                            snapshot
                                                .data!.dipinjam[index].title,
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white)),
                                        subtitle: Text(
                                            snapshot
                                                .data!.dipinjam[index].author,
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      ListTile(
                                        title: Text(
                                            'Tanggal Pengembalian: ${snapshot.data!.dipinjam[index].deadline}',
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Call the return_book API endpoint
                                          final response = await http.get(
                                            Uri.parse(
                                                'https://planetbuku1.firdausfarul.repl.co/borrowed_book_list/return-book/${snapshot.data!.dipinjam[index].peminjamanId}'), // Replace with your actual URL
                                          );

                                          if (response.statusCode == 200) {
                                            // Book returned successfully, update the UI
                                            setState(() {
                                              snapshot.data!.dipinjam
                                                  .removeAt(index);
                                            });
                                          } else {
                                            // Handle error case, e.g., show an error message
                                            print(
                                                'Failed to return book: ${response.statusCode}');
                                          }
                                        },
                                        child: Text('Kembalikan Buku'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                      ),
                      Text(
                        'Buku yang Dikembalikan',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.dikembalikan.length,
                              itemBuilder: (BuildContext, int index) {
                                if (true) {
                                  return Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Align the children in the center vertically
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // Align the children in the center horizontally
                                      children: [
                                        Image.network(snapshot
                                            .data!.dikembalikan[index].image),
                                        ListTile(
                                          title: Text(
                                              snapshot.data!.dikembalikan[index]
                                                  .title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          subtitle: Text(
                                              snapshot.data!.dikembalikan[index]
                                                  .author,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        ListTile(
                                          title: Text('Kesan',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          subtitle: Text(
                                              snapshot.data!.dikembalikan[index]
                                                  .kesan,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        KesanFormPage(
                                                            bookId: snapshot
                                                                .data!
                                                                .dikembalikan[
                                                                    index]
                                                                .bookId)),
                                              );
                                            },
                                            child: Text('Add Kesan'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }))
                    ],
                  );
                }
              }
            }));
  }
}
