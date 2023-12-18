import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:planetbuku/EditBuku/models/book.dart';
import 'package:planetbuku/EditBuku/screens/aplikasi.dart';
import 'package:planetbuku/drawer.dart';
import 'package:planetbuku/home/screens/aplikasi_admin.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

List<Book> books = [];

// class EditFormPage extends StatefulWidget {
//   const EditFormPage({super.key});

//   @override
//   State<EditFormPage> createState() => _EditFormPageState();
// }
class EditBookPage extends StatefulWidget {
  final Book item;

  const EditBookPage({Key? key, required this.item}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  int _stock = 0;
  String _author = "";
  String _isbn = "";
  String _publisher = "";
  String _imageS = "";
  String _imageM = "";
  String _imageL = "";
  int _publicationYear = 0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _publicationYearController = TextEditingController();
  TextEditingController _isbnController = TextEditingController();
  TextEditingController _publisherController = TextEditingController();
  TextEditingController _imageSController = TextEditingController();
  TextEditingController _imageMController = TextEditingController();
  TextEditingController _imageLController = TextEditingController();


@override
  void initState() {
    super.initState();

    // Initialize the controllers with the values from the widget
    _titleController.text = widget.item.fields.title;
    _stockController.text = widget.item.fields.stock.toString();
    _authorController.text = widget.item.fields.author;
    _publicationYearController.text = widget.item.fields.publicationYear.toString();
    _isbnController.text = widget.item.fields.isbn;
    _publisherController.text = widget.item.fields.publisher;
    _imageSController.text = widget.item.fields.imageS;
    _imageMController.text = widget.item.fields.imageM;
    _imageLController.text = widget.item.fields.imageL;
  }
  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Edit Buku',
          ),
        ),
      backgroundColor: Colors.grey[850],
        foregroundColor:  Colors.pink,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Judul Buku",
                    labelText: "Judul Buku",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Judul tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:_stockController,
                  decoration: InputDecoration(
                    hintText: "Stock",
                    labelText: "Stock",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  
                  onChanged: (String? value) {
                    setState(() {
                      _stock = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Stock tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Stock harus berupa angka!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:_authorController,
                  decoration: InputDecoration(
                    hintText: "Author",
                    labelText: "Author",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _author = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Author tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:_publicationYearController,
                  decoration: InputDecoration(
                    hintText: "Publication Year",
                    labelText: "Publication Year",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  
                  onChanged: (String? value) {
                    setState(() {
                      _publicationYear = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Publication Year tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Publication Year harus berupa angka!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:_isbnController,
                  decoration: InputDecoration(
                    hintText: "ISBN Buku",
                    labelText: "ISBN Buku",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _isbn = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "ISBN tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:_publisherController,
                  decoration: InputDecoration(
                    hintText: "Penerbit Buku",
                    labelText: "Penerbit Buku",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _publisher = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama Penerbit tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:_imageSController,
                  decoration: InputDecoration(
                    hintText: "Foto Buku S",
                    labelText: "Foto Buku S",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _imageS = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "link foto tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:_imageMController,
                  decoration: InputDecoration(
                    hintText: "Foto Buku M",
                    labelText: "Foto Buku M",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _imageM = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "link foto tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:_imageLController,
                  decoration: InputDecoration(
                    hintText: "Foto Buku L",
                    labelText: "Foto Buku L",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _imageL = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "link foto tidak boleh kosong!";
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
                      backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 201, 142, 124)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                          // Kirim ke Django dan tunggu respons
                          // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                          final response = await request.postJson(
                          "https://planetbuku1.firdausfarul.repl.co/adminbook/edit-flutter/${widget.item.pk}/",
                          jsonEncode(<String, dynamic>{
                              'title': _title,
                              'stock': _stock.toString(),
                              'author': _author,
                              'publication_year': _publicationYear.toString(),
                              'publisher': _publisher,
                              'isbn': _isbn,
                              'image_s': _imageS,
                              'image_m': _imageM,
                              'image_l': _imageL,
                              
                          }));
                          if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                              content: Text("Perubahan berhasil disimpan!"),
                              ));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditBuku()),
                              );
                          } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content:
                                      Text("Terdapat kesalahan, silakan coba lagi."),
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
            ],
          ),
        ),
      ),
    );
  }
}