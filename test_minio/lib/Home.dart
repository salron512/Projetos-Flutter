import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var passadadosAlbum;
  var passadadosNome;
  var resultado;
  int index;
  _consulta() async {
    String url =
        "https://lista-albuns-default-rtdb.firebaseio.com/artista.json";

    http.Response response = await http.get(url);
    setState(() {
      resultado = jsonDecode(response.body);
    });
    print("Status: " + response.statusCode.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _consulta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Albuns")),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text("Titulo"),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.ac_unit),
              title: Text("Primeira tela"),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SegundaTela()));
                setState(() {
                  index = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Segunda Tela'),
              onTap: () {
                setState(() {
                  index = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: resultado == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Serj tankian"]["album1"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Serj tankian"]["nome"].toString()),
                      onTap: () {
                        setState(() {
                          passadadosAlbum = resultado["Serj tankian"]["album1"];
                          passadadosNome = resultado["Serj tankian"]["nome"];
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Serj tankian"]["album2"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Serj tankian"]["nome"].toString()),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Serj tankian"]["album3"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Serj tankian"]["nome"].toString()),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Mike Shinoda"]["album1"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Mike Shinoda"]["nome"].toString()),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
