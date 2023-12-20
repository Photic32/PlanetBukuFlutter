import 'package:flutter/material.dart';
import 'package:planetbuku/home/screens/aplikasi.dart';
import 'package:planetbuku/LihatBuku/screens/aplikasi.dart';
import 'package:planetbuku/DaftarBukuDipinjam/screens/aplikasi.dart';
import 'package:planetbuku/home/screens/cart.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[850],
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
            child: Column(
              children: [
                Text(
                  'PlanetBuku',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Browse Planet Buku Here",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Colors.pink,),
            title: const Text('Home',
                style: TextStyle(color: Colors.white)),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shelves, color: Colors.pink,),
            title: const Text('Browse Books',
                style: TextStyle(color: Colors.white)),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LihatBuku(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_rounded, color: Colors.pink,),
            title: const Text('Borrowed Books',
                style: TextStyle(color: Colors.white)),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DaftarBukuDipinjam(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.trolley, color: Colors.pink,),
            title: const Text('Cart',
                style: TextStyle(color: Colors.white)),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
