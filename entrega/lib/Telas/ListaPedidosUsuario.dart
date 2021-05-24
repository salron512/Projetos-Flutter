import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';

class ListaPedidosUsuario extends StatefulWidget {
  @override
  _ListaPedidosUsuarioState createState() => _ListaPedidosUsuarioState();
}

class _ListaPedidosUsuarioState extends State<ListaPedidosUsuario> {
  StreamController _streamController = StreamController.broadcast();

  _recuperaPedidos() {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .orderBy("horaPedido", descending: true)
        .where("idUsuario", isEqualTo: uid)
        .snapshots()
        .listen((event) {
      if (mounted) {
        _streamController.add(event);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus pedidos"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _streamController.stream,
          // ignore: missing_return
          builder: (context, snapshot) {

          },
        ),
      ),
    );
  }
}
