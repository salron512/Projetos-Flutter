import 'dart:math';

import 'package:cara_ou_coroa/main.dart';
import 'package:flutter/material.dart';

class TelaSegundaria extends StatefulWidget {

 int valor;
TelaSegundaria(this.valor);

  @override
  _TelaSegundariaState createState() => _TelaSegundariaState();
}

class _TelaSegundariaState extends State<TelaSegundaria> {
  var imagenResultado;
  
  @override
  Widget build(BuildContext context) {
    
    
    if(widget.valor == 0){
      setState(() {
        imagenResultado =  AssetImage("images/moeda_coroa.png");
      });
    }else{
      setState(() {
        imagenResultado =  AssetImage("images/moeda_cara.png");
      });
    }


    return Scaffold(
      backgroundColor: Color(0xff61bd8c),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Padding(padding: EdgeInsets.only(bottom: 32),
              child: Image(image: imagenResultado),
            ),
            GestureDetector(
              child: Image.asset("images/botao_voltar.png"),
              onTap: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
