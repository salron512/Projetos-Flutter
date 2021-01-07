import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> retorno;
  _api() async {
    String url =
        "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita";
    http.Response response;

    response = await http.get(url);
     retorno = json.decode(response.body)["drinks"];

     var cont = retorno.length;

    for(int i = 0; i <= cont ; i++ )

      print("resultado" + retorno[i].toString());


  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          RaisedButton(
              child: Text("atualizar"),
              onPressed: () {
                _api();
              })
        ]),
      ),
    );
  }
}
