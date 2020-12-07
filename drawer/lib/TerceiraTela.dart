import 'package:flutter/material.dart';

class TerceiraTela extends StatefulWidget {
  @override
  _TerceiraTelaState createState() => _TerceiraTelaState();
}

class _TerceiraTelaState extends State<TerceiraTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Segunda Tela"),
      ),
    );
  }
}
