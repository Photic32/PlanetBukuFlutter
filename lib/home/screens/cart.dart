import 'package:flutter/material.dart';
import 'package:planetbuku/drawer.dart';
import 'package:planetbuku/home/screens/aplikasi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:planetbuku/home/models/book.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<List<Book>> fetchProduct() async {
    final request = context.watch<CookieRequest>();
    Map<String, dynamic> jsonData = request.getJsonData();
    int idUser = jsonData["user_id"];
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://planetbuku1.firdausfarul.repl.co/get-buku-keranjang-id/$idUser/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // melakukan konversi data json menjadi object Product
    List<Book> listKeranjang = [];
    for (var d in data) {
      if (d != null) {
        listKeranjang.add(Book.fromJson(d));
      }
    }
    // Keranjang keranjangUser = list_keranjang[0];
    // List<int> nomorBuku = keranjangUser.fields.bookList;

    return listKeranjang;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: const Text(
            "Cart",
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
                        "Tidak ada data produk.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                    "${snapshot.data![index].fields.imageM}"),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "${snapshot.data![index].fields.title}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Author : ${snapshot.data![index].fields.author}",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Stock : ${snapshot.data![index].fields.stock}",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.pink,
                                      ),
                                      onPressed: () async {
                                        int idUser =
                                            request.jsonData["user_id"];
                                        int bookId = snapshot.data![index].pk;
                                        debugPrint(bookId.toString());
                                        final response = await request.postJson(
                                            "https://planetbuku1.firdausfarul.repl.co/handle-cart-flutter",
                                            jsonEncode(<String, dynamic>{
                                              'action': "Borrow",
                                              'idUser': idUser,
                                              'bookId': bookId
                                            }));
                                        debugPrint(response.toString());
                                        if (response['status'] == 'success') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text("Buku berhasil dipinjam"),
                                          ));
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Terdapat kesalahan, silakan coba lagi."),
                                          ));
                                        }
                                      },
                                      child: const Text('Borrow'),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.pink,
                                      ),
                                      onPressed: () async {
                                        int idUser =
                                            request.jsonData["user_id"];
                                        int bookId = snapshot.data![index].pk;

                                        final response = await request.postJson(
                                            "https://planetbuku1.firdausfarul.repl.co/handle-cart-flutter",
                                            jsonEncode(<String, String>{
                                              'action': "Remove",
                                              'idUser': idUser.toString(),
                                              'bookId': bookId.toString()
                                            }));
                                        if (response['status'] == 'success') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text("Buku berhasil diremove"),
                                          ));
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Terdapat kesalahan, silakan coba lagi."),
                                          ));
                                        }
                                      },
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                }
              }
            }));
  }
}
