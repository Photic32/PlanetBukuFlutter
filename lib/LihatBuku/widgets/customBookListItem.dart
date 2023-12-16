import 'package:flutter/material.dart';

class CustomBookListItem extends StatelessWidget {
  const CustomBookListItem({
    Key? key,
    required this.title,
    required this.author,
    required this.publicationYear,
    required this.stock,
    required this.thumbnailUrl,
  }) : super(key: key);

  final String title;
  final String author;
  final int publicationYear;
  final int stock;
  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: SizedBox(
                width: 80,
                child: Image.network(
                  thumbnailUrl,
                  fit: BoxFit.fill,
                ),
              )),
          Expanded(
            flex: 3,
            child: _BookDescription(
              title: title,
              author: author,
              publicationYear: publicationYear,
              stock: stock,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookDescription extends StatelessWidget {
  const _BookDescription({
    required this.title,
    required this.author,
    required this.publicationYear,
    required this.stock,
  });

  final String title;
  final String author;
  final int publicationYear;
  final int stock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.pink,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            '$author | $publicationYear',
            style: const TextStyle(fontSize: 16.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          const SizedBox(height: 16),
          if (stock > 0)
            const Text(
              'In stock',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          if (stock <= 0)
            const Text(
              'Out of stock',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
        ],
      ),
    );
  }
}
