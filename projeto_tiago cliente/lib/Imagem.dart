import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Imagem extends StatefulWidget {
  DocumentSnapshot dados;
  Imagem(this.dados);

  @override
  _ImagemState createState() => _ImagemState();
}

class _ImagemState extends State<Imagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor
        ),
          child: Center(
        // ignore: missing_required_param
        child: Padding(
            padding: EdgeInsets.all(16),
            child: PhysicalModel(
              color: Colors.white,
              elevation: 8,
              child: Image.network(
                widget.dados["urlGaleria"],
              ),
            )),
      )),
    );
  }
}
