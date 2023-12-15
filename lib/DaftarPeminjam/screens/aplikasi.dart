import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:planetbuku/DaftarPeminjam/models/user.dart';
import 'package:planetbuku/drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class DaftarPeminjam extends StatefulWidget {
  const DaftarPeminjam({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<DaftarPeminjam> {
  Future<List<User>> fetchUser() async {
    final request = context.watch<CookieRequest>();
    var response = await request.get(
      'http://127.0.0.1:8000/adminusers/all_user_json/',
    );
    // melakukan konversi data json menjadi object Product
    List<User> list_user = [];
    for (var d in response) {
      if (d != null) {
        list_user.add(User.fromJson(d));
      }
    }
    return list_user;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Product'),
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchUser(),
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
                      itemBuilder: (_, index) => InkWell(
                              child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data![index].username}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text("${snapshot.data![index].userId}"),
                                const SizedBox(height: 10),
                                Text(
                                    "${snapshot.data![index].jumlahBukuDipinjam}"),
                              ],
                            ),
                          )));
                }
              }
            }));
  }
}
