import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gif/constants.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _search = "";
  int? _offser;

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search.isEmpty) {
      response = await http.get(Uri.parse(Constants.getTrading));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=Fga2SHVIo5A2NFKIYaJuSfyW18vOl2l8&q=$_search&limit=19&offset=$_offser&rating=g&lang=pt&bundle=messaging_non_clips"));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    _getGifs().then((value) {
      print(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Pesquise aqui!",
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
            SizedBox(
              height: height,
            ),
            FutureBuilder(
              future: _getGifs(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _creatGifTable(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  int _getCount(List data) {
    if (_search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _creatGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return Expanded(
      child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: _getCount(snapshot.data["data"]),
          itemBuilder: (context, index) {
            if (_search.isEmpty || index < snapshot.data["data"].length) {
              return GestureDetector(
                child: Image.network(
                  snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  fit: BoxFit.cover,
                ),
                onTap: () {},
              );
            } else {
              return Container(
                child: GestureDetector(
                    child: const Column(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                )),
              );
            }
          }),
    );
  }
}
