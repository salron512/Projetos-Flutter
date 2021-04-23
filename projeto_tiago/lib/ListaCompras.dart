import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListaCompras extends StatefulWidget {
  ListaCompras({Key key}) : super(key: key);

  @override
  _ListaComprasState createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  StreamController _streamController = StreamController.broadcast();
  String _totalCompra = "0";
  bool _mostraBottomBar = true;
  List<dynamic> _listaCompras = [];
  double _totalCesta = 0;

  _recuperaLista() {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String uid = auth.currentUser.uid;
    List<QueryDocumentSnapshot> snapshot;
    Map<String, dynamic> dados;

    var stream = db
        .collection("listaPendente")
        .doc(uid)
        .collection(uid)
        .orderBy("nome", descending: false)
        .snapshots();

    stream.listen((event) {
      _streamController.add(event);
      snapshot = event.docs;
      snapshot.forEach((element) {
        dados = element.data();
        print("preco total " + dados["precoTotal"]);
        // _listaCompras.add(dados["precoTotal"]);
        setState(() {
          _totalCesta =
              _totalCesta + double.tryParse(dados["precoTotal"]).toDouble();
          _totalCompra = _totalCesta.toString();
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Carrinho de Compras"),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                stream: _streamController.stream,
                // ignore: missing_return
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:

                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      QuerySnapshot querySnapshot = snapshot.data;
                      if (querySnapshot.docs.length == 0) {
                        return Center(
                          child: Text("Sem produtos"),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (context, indice) {
                            List<DocumentSnapshot> listaDoc =
                                querySnapshot.docs.toList();
                            DocumentSnapshot dados = listaDoc[indice];
                            return Card(
                              child: ListTile(
                                leading: Image.network(dados["urlimagem"],
                                width: 50,
                                height: 50,
                                ),
                                title: Text(dados["nome"]),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Marca: " + dados["marca"]),
                                     Text("Quantidade: " + dados["quantidade"]),
                                    Text("Preço unit R\$: " + dados["precoUnitario"]),
                                    Text("Preço total R\$: " + dados["precoTotal"]),
                                  ],
                                ),
                              ),
                              
                            );
                          },
                        );
                      }
                      break;
                  }
                },
              )),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    title: Text(
                      "Valor total",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(
                      "R\$ " + _totalCompra,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: _mostraBottomBar,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        child: Text(
                          "Confirmar pedido",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {},
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
