import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Dados.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _auth = FirebaseAuth.instance;

  Dados dados = Dados();
  List<dynamic> resultado;
  int index;
  Future _consulta() async {
    var token = await _auth.currentUser.getIdToken();

    String url =
        "https://lista-albuns-default-rtdb.firebaseio.com/albuns.json?auth=$token";

    http.Response response = await http.get(url);
    setState(() {
      resultado = jsonDecode(response.body);
    });
    print("Status: " + response.statusCode.toString());
    print("retorno API: " + resultado.toString());
    return resultado;
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
        appBar: AppBar(
          title: Text("Lista Albuns"),
          actions: [
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.exit_to_app),
              ),
              onTap: () {
                _auth.signOut();
                Navigator.popAndPushNamed(context, "/login");
              },
            ),
          ],
        ),
        body: resultado == null
            ? Container(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    // valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
                  ),
                ),
              )
            : Container(
          color: Colors.blue,
          child: ListView.builder(
              itemCount: resultado.length,
              // ignore: missing_return
              itemBuilder: (_, indice) {
                var albuns = resultado[indice];
                return Card(
                    child: ListTile(
                      title: Text("Titulo: " + albuns["titulo"]),
                      subtitle: Text("Artista: " + albuns["artista"]),
                      onTap: () {
                        setState(() {
                          dados.album = albuns["titulo"];
                          dados.ano = albuns["ano"].toString();
                          dados.duracao = albuns["duracao"].toString();
                          dados.totalFaixas = albuns["total_faixas"].toString();
                          dados.nome = albuns["artista"].toString();
                          dados.object = albuns["imagemCapa"];
                          dados.objectUpload = albuns["pasta"];
                        });
                        Navigator.pushNamed(context, "/detalhes",
                            arguments: dados);
                      },
                    )
                );
              }
          ),
        )
    );
  }
}
