import 'package:flutter/material.dart';
import 'package:planetbuku/home/screens/aplikasi_guest.dart';
import 'package:planetbuku/LihatBuku/screens/aplikasi.dart';
import 'package:planetbuku/home/screens/login.dart';
import 'package:provider/provider.dart';

class GuestDrawer extends StatelessWidget {
  const GuestDrawer({super.key});

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
                    builder: (context) => HomeGuestPage(),
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
                    builder: (context) => LihatBuku(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.login, color: Colors.pink,),
            title: const Text('Login',
                style: TextStyle(color: Colors.white)),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
          ),

        ],
      ),
    );
  }
}
