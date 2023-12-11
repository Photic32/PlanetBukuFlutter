import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:planetbuku/DaftarPeminjam/models/user.dart';
import 'package:planetbuku/drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:planetbuku/DaftarPeminjam/models/peminjam.dart';

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
      'https://planetbuku1.firdausfarul.repl.co/adminusers/search_book/?user_id=' +
          temp.userId.toString() +
          '&query=' +
          query,
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
        'https://planetbuku1.firdausfarul.repl.co/adminusers/kembali_buku/' +
            bookId,
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
          'https://planetbuku1.firdausfarul.repl.co/adminusers/edit_peminjaman/' +
              bookId.toString(),
          jsonEncode(<String, String>{
            'tanggal_pengembalian': newReturnDate.year.toString() +
                '-' +
                newReturnDate.month.toString() +
                '-' +
                newReturnDate.day.toString(),
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
      ),
      drawer: const LeftDrawer(), // Assuming LeftDrawer is a defined widget
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
          Map<int, TextEditingController> _controllers = {};

          return Column(children: <Widget>[
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Buku yang dipinjam oleh ${widget.pengguna.username}",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Books',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
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
                String tanggal = buku.deadline.day.toString() +
                    '-' +
                    buku.deadline.month.toString() +
                    '-' +
                    buku.deadline.year.toString();
                if (!_controllers.containsKey(index)) {
                  _controllers[index] = TextEditingController();
                }
                var _daysController = _controllers[index];
                return Card(
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
                              width: 50,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    buku.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    buku.author,
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'ISBN : ${buku.isbn}',
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Status : ${buku.status}',
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Deadline Pengembalian: ${tanggal}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6)),
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
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextField(
                                    //set size field
                                    style: TextStyle(fontSize: 14),
                                    cursorHeight: 1,

                                    controller: _daysController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Additional days',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),

                              // Your existing ElevatedButton for extending the loan
                              ElevatedButton(
                                onPressed: () {
                                  if (_daysController!.text.isNotEmpty) {
                                    int additionalDays =
                                        int.tryParse(_daysController.text) ?? 0;
                                    DateTime currentReturnDate = buku.deadline;
                                    DateTime newReturnDate = currentReturnDate
                                        .add(Duration(days: additionalDays));

                                    // Here, you would call your logic to update the loan with the new return date.
                                    // For example:
                                    extendLoan(
                                        buku.peminjamanId, newReturnDate);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red),
                                child: Text('Extend',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // Return book logic
                                  returnBook(buku.peminjamanId.toString());
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red),
                                child: Text('Return',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          )
                        else if (buku.status == 'dikembalikan')
                          Row(
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
