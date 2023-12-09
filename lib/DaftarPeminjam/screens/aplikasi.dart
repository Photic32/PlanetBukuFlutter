import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:planetbuku/DaftarPeminjam/models/user.dart';
import 'package:planetbuku/drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:planetbuku/DaftarPeminjam/screens/user_individu.dart';

class DaftarPeminjam extends StatefulWidget {
  const DaftarPeminjam({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<DaftarPeminjam> {
  Future<List<User>> fetchUser() async {
    final request = context.watch<CookieRequest>();
    var response = await request.get(
      'https://planetbuku1.firdausfarul.repl.co/adminusers/all_user_json/',
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
          title: const Text('Daftar Peminjam'),
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
                        "Tidak ada User untuk Saat Ini.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Daftar Peminjam', // Text yang menandakan toko
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        snapshot.data[index].username,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'User Id : ${snapshot.data[index].userId.toString()}',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Books Borrowed: ${snapshot.data[index].jumlahBukuDipinjam}',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserIndividu(
                                        pengguna: snapshot.data[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                ;
              }
            }));
  }
}
