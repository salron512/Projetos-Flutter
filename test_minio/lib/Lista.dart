import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_minio/Login.dart';
import 'Home.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  var auth = FirebaseAuth.instance;
  int index = 0;

  List<Widget> _listatelas = [
    Home(),

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
              leading: Icon(Icons.ac_unit),
              title: Text("Primeira tela"),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                setState(() {
                  index = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Deslogar'),
              onTap: () {
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  auth.signOut();
                });
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
