import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifScreen extends StatelessWidget {
  const GifScreen({super.key, required this.gifData});

  final Map gifData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          gifData["title"],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share( gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
      ),
      body: Center(
        child: Image.network(
          gifData["images"]["fixed_height"]["url"],
        ),
      ),
    );
  }
}
