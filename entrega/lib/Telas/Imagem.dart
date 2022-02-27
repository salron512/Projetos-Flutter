import 'package:cached_network_image/cached_network_image.dart';
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
              // color: Theme.of(context).accentColor
              ),
          child: Center(
            // ignore: missing_required_param
            child: Padding(
                padding: EdgeInsets.all(16),
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 8,
                  child:
                  CachedNetworkImage(
                    imageUrl: widget.dados["urlGaleria"],
                    width: 500,
                    height: 500, 
                  ) ,
                  /*
                  Image.network(
                    widget.dados["urlGaleria"],
                    width: 500,
                    height: 500,
                    //fit: BoxFit.contain,
                  ),
                  */
                )),
          )),
    );
  }
}
