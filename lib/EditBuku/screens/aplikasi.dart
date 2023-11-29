import 'package:flutter/material.dart';
import 'package:planetbuku/drawer.dart';

class EditBuku extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Buku',
      home: Scaffold(
        drawer: const LeftDrawer(),
        appBar: AppBar(
          title: Text('Edit Buku'),
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: Image.network(
            'https://pbs.twimg.com/profile_banners/1223948402209116165/1686672636/1500x500',
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                Text('Failed to load image.'),
          ),
        ),
      ),
    );
  }
}
