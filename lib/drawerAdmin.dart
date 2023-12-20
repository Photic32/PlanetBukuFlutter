import 'package:flutter/material.dart';
import 'package:planetbuku/home/screens/aplikasi_admin.dart';
import 'package:planetbuku/DaftarPeminjam/screens/aplikasi.dart';
import 'package:planetbuku/EditBuku/screens/aplikasi.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

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
                    builder: (context) => HomeAdminPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_attributes, color: Colors.pink,),
            title: const Text('Edit Books',
                style: TextStyle(color: Colors.white)),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditBuku(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.pink,),
            title: const Text('Edit Borrowers',
                style: TextStyle(color: Colors.white)),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DaftarPeminjam(),
                  ));
            },
          ),

        ],
      ),
    );
  }
}
