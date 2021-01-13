import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

import 'Dados.dart';


class Pesquisa extends StatefulWidget {
  Dados dados;
  Pesquisa({this.dados});
  @override
  _PesquisaState createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {

  _recuperadadosJson() async{
    String url = "https://lista-albuns-default-rtdb.firebaseio.com/artista.json";
    http.Response response = await http.get(url);
    var resposta = await jsonDecode(response.body);
    print("Status Code " + response.statusCode.toString());
    print("resposta "+ resposta.toString());


  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperadadosJson();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Pesquisa"),
      ),
    );
  }
}
