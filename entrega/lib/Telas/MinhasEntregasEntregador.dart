import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';

class MinhasEntregasEntregador extends StatefulWidget {
  @override
  _MinhasEntregasEntregadorState createState() =>
      _MinhasEntregasEntregadorState();
}

class _MinhasEntregasEntregadorState extends State<MinhasEntregasEntregador> {
  StreamController _streamController = StreamController.broadcast();

  _recuperaEntregas() {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .orderBy("horaPedido", descending: true)
        .where("idEntregador", isEqualTo: uid)
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
    _recuperaEntregas();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
