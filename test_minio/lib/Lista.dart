import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_minio/Login.dart';
import 'package:test_minio/Pesquisa.dart';
import 'Dados.dart';
import 'Home.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  Dados dados = Dados();
  var auth = FirebaseAuth.instance;
  int index = 0;

  List<Widget> _listatelas = [
    Home(),
    Pesquisa()

  ];
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
                    Text("Opções"),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.library_music),
              title: Text("Lista de albuns"),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                setState(() {
                  index = 0;
                  Navigator.pop(context);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Pesquisa()));
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("Pesquisar  albuns"),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                setState(() {
                  dados.parametroPesquisa = "album";
                  index = 1;
                  Navigator.pop(context);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Pesquisa()));
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.pageview),
              title: Text("Pesquisar artistas"),
              onTap: () {
                dados.parametroPesquisa = "artista";
                //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                setState(() {
                  index = 1;
                 Navigator.pop(context);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Pesquisa()));
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Deslogar'),
              onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  auth.signOut();
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: _listatelas[index] ,
    )
    );
  }
}
