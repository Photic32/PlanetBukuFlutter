import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:planetbuku/home/screens/aplikasi_guest.dart';
import 'package:planetbuku/home/screens/login.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login to PlanetBuku',
      theme: ThemeData(
        canvasColor: Colors.grey[850],
        primarySwatch: Colors.pink,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _usernameController,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                labelText: 'Username',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _password1Controller,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _password2Controller,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                labelText: 'Confirm Your Password',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        textStyle: const TextStyle(color: Colors.white)),
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password1 = _password1Controller.text;
                      String password2 = _password2Controller.text;

                      // Cek kredensial
                      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                      // Untuk menyambungkan Android emulator dengan Django pada localhost,
                      // gunakan URL http://10.0.2.2/
                      //https://planetbuku1.firdausfarul.repl.co/auth/register/
                      //https://planetbukutes-95487a8dd763.herokuapp.com/auth/register/
                      final response = await request.post(
                          "https://planetbuku1.firdausfarul.repl.co/auth/register/",
                          {
                            'username': username,
                            'password1': password1,
                            'password2': password2,
                          });
                      if (response['status'] == true) {
                        String message = response['message'];
                        String uname = response['username'];
                        // String temp = response.toString();
                        // debugPrint('$temp');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                              content:
                                  Text("$message Selamat datang, $uname.")));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Signup Gagal'),
                            content: Text(response['message']),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text('Register'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        textStyle: const TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                            content: Text("Selamat datang, Guest User.")));
                    },
                    child: const Text('Login Page'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        textStyle: const TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeGuestPage()),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                            content: Text("Selamat datang, Guest User.")));
                    },
                    child: const Text('Login as Guest'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
