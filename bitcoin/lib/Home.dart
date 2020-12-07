import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _preco ="0" ;
    void retornapreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response  = await http.get(url);


    Map<String, dynamic> retorno = json.decode(response.body);
    setState(() {
      _preco = retorno["BRL"]["last"].toString();
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
           Image.asset("images/bitcoin.png"),
            Padding(padding: EdgeInsets.all(32),
            child: Text("R\$ "+ _preco,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
            ),
            ),
            RaisedButton(
              child: Text("Atualizar",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
              ),
                color: Colors.orange,
                onPressed: retornapreco
            )
          ],
        ),
      ),
    );
  }
}
