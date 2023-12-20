import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:planetbuku/DaftarBukuDipinjam/models/BukuKesan.dart';
import 'package:planetbuku/drawer.dart';
import 'package:provider/provider.dart';
import 'package:planetbuku/DaftarBukuDipinjam/screens/aplikasi.dart';

List<BukuKesan> books = [];

class KesanFormPage extends StatefulWidget {
  final int bookId;

  const KesanFormPage({Key? key, required this.bookId}) : super(key: key);

  @override
  State<KesanFormPage> createState() => _KesanFormPageState();
}

class _KesanFormPageState extends State<KesanFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _kesan = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Tambahkan Kesan kamu',
            ),
          ),
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
        drawer: const LeftDrawer(),
        backgroundColor: Colors.grey[850],
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "kesan",
                          labelText: "kesan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _kesan = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "kesan tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 201, 142, 124)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Kirim ke Django dan tunggu respons
                              // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                              final response = await request.postJson(
                                  "https://planetbuku1.firdausfarul.repl.co/borrowed_book_list/add-kesan-flutter/${widget.bookId}",
                                  jsonEncode(<String, String>{
                                    'kesan': _kesan,
                                  }));
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("kesan berhasil disimpan!"),
                                ));
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DaftarBukuDipinjam()),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Terdapat kesalahan, silakan coba lagi."),
                                ));
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
                  ]),
            )));
  }
}
