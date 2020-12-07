

import 'dart:math';

import 'package:flutter/material.dart';

void main(){

  runApp(MaterialApp(
    home: Home() ,
    debugShowCheckedModeBanner: false,
  ));

}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _frase = [
    "frase1",
    "frase2",
    "frase3",
    "frase4"
  ];

  var _texto = "Clique abaixo para gerar um frase!";

  void _gerarFrases() {

    var numeroSorteado = new Random().nextInt(_frase.length);

   setState(() {
     _texto = _frase[numeroSorteado];
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Frases do dia",
        //textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          /*width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 3,color: Colors.amber)
          ),*/
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [
              Image.asset("images/logo.png"),
              Text(
                _texto,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.black
                ),
              ),
              RaisedButton(
                  child: Text("Nova Frase",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  color: Colors.green,
                  onPressed: _gerarFrases,
              )
            ],
          ),
        ),
      )
    );
  }
  }

