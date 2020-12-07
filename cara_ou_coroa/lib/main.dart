import 'dart:math';

import 'package:cara_ou_coroa/TelaSegundaria.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(
      MaterialApp(
    home: Home() ,
        debugShowCheckedModeBanner: false,
  ));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  void _abrirResultado(){
    int _numero = new Random().nextInt(2);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaSegundaria(_numero) )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff61bd8c),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Padding(
                padding: EdgeInsets.only(bottom: 32),
            child: Image.asset("images/logo.png") ,
              ),
            GestureDetector(
              child: Image.asset("images/botao_jogar.png"),
              onTap: _abrirResultado,
            )
          ],
        ),
      ),
    );
  }
}
