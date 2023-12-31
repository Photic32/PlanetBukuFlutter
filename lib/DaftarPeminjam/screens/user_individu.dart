import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:planetbuku/DaftarPeminjam/models/user.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:planetbuku/DaftarPeminjam/models/peminjam.dart';
import 'package:planetbuku/drawerAdmin.dart';

class UserIndividu extends StatefulWidget {
  final User pengguna;
  const UserIndividu({Key? key, required this.pengguna}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<UserIndividu> {
  TextEditingController searchController = TextEditingController();
  Future<Peminjam> fetchUser(String query) async {
    final request = context.watch<CookieRequest>();
    User temp = widget.pengguna;
    var response = await request.get(
      'https://planetbuku1.firdausfarul.repl.co/adminusers/search_book/?user_id=${temp.userId}&query=$query',
    );
    // melakukan konversi data json menjadi object Product
    Peminjam peminjam = Peminjam.fromJson(response);
    return peminjam;
  }

  //declare function return book
  Future<void> returnBook(String bookId) async {
    final request = context.read<CookieRequest>();
    try {
      var response = await request.get(
        'https://planetbuku1.firdausfarul.repl.co/adminusers/kembali_buku/$bookId',
      );
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil dikembalikan'),
          ),
        );
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku gagal dikembalikan'),
        ),
      );
    }
  }

  //declare function extend loan
  Future<void> extendLoan(int bookId, DateTime newReturnDate) async {
    final request = context.read<CookieRequest>();
    try {
      var response = await request.postJson(
          'https://planetbuku1.firdausfarul.repl.co/adminusers/edit_peminjaman/$bookId',
          jsonEncode(<String, String>{
            'tanggal_pengembalian': '${newReturnDate.year}-${newReturnDate.month}-${newReturnDate.day}',
          }));
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deadline berhasil diperpanjang'),
          ),
        );
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loan gagal diperpanjang'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peminjam'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[850],
      drawer: const AdminDrawer(), // Assuming LeftDrawer is a defined widget
      body: FutureBuilder<Peminjam>(
        future: fetchUser(searchController.text),
        builder: (BuildContext context, AsyncSnapshot<Peminjam> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada Buku untuk Saat Ini."));
          }

          var peminjam = snapshot.data!;
          Map<int, TextEditingController> controllers = {};

          return Column(children: <Widget>[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Buku yang dipinjam oleh ${widget.pengguna.username}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Books',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    icon: const IconTheme(
                      data: IconThemeData(
                        color: Colors.white,
                      ),
                      child: Icon(Icons.search),
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: peminjam.bukuDipinjam.length,
              itemBuilder: (BuildContext context, int index) {
                var buku = peminjam.bukuDipinjam[index];
                String tanggal = '${buku.deadline.day}-${buku.deadline.month}-${buku.deadline.year}';
                if (!controllers.containsKey(index)) {
                  controllers[index] = TextEditingController();
                }
                var daysController = controllers[index];
                return Card(
                  color: Colors.grey[800],
                  elevation: 4.0,
                  margin: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                              buku.image,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    buku.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    buku.author,
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'ISBN : ${buku.isbn}',
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Status : ${buku.status}',
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Deadline Pengembalian: $tanggal',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (buku.status == 'dipinjam')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextField(
                                    //set size field
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),

                                    controller: daysController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Hari tambahan',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (daysController!.text.isNotEmpty) {
                                    int additionalDays =
                                        int.tryParse(daysController.text) ?? 0;
                                    DateTime currentReturnDate = buku.deadline;
                                    DateTime newReturnDate = currentReturnDate
                                        .add(Duration(days: additionalDays));

                                    extendLoan(
                                        buku.peminjamanId, newReturnDate);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink),
                                child: const Text('Extend',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // Return book logic
                                  returnBook(buku.peminjamanId.toString());
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink),
                                child: const Text('Return',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          )
                        else if (buku.status == 'dikembalikan')
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Buku sudah dikembalikan",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ))
          ]);
        },
      ),
    );
  }
}
