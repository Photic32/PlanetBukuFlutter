import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:planetbuku/DaftarBukuDipinjam/screens/aplikasi.dart';
import 'package:planetbuku/home/screens/aplikasi.dart';
import 'package:planetbuku/DaftarPeminjam/screens/aplikasi.dart';
import 'package:planetbuku/LihatBuku/screens/aplikasi.dart';
import 'package:planetbuku/EditBuku/screens/aplikasi.dart';

class ShopCard extends StatelessWidget {
  final ShopItem item;

  const ShopCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: Colors.pink,
      child: InkWell(
        // Area responsive terhadap sentuhan
        // Area responsif terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));

          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Daftar Buku Dipinjam") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DaftarBukuDipinjam(),
                ));
          } else if (item.name == "Peminjam Buku") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DaftarPeminjam(),
                ));
          } else if (item.name == "Lihat Buku") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LihatBuku(),
                ));
          } else if (item.name == "Edit Buku") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBuku(),
                ));
          } else if (item.name == "Logout") {
            final response = await request.logout(
                // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                "http://127.0.0.1:8000/auth/logout/");
            String message = response["message"];
            if (response['status']) {
              String uname = response["username"];
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $uname."),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message"),
              ));
            }
          }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          color: Colors.pink,
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShopItem {
  final String name;
  final IconData icon;

  ShopItem(this.name, this.icon);
}
