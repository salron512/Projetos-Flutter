import 'package:flutter/material.dart';

class Produtos extends StatefulWidget {
  @override
  _ProdutosState createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 15),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("teste")
            ],
          ),
          )
        ),
      ),
      
    );
  }
}