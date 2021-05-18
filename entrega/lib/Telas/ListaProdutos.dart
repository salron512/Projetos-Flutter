import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';

class ListaProdutos extends StatefulWidget {
  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  StreamController _streamController = StreamController.broadcast();

  _recuperaListaProdutos() {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    var stream = FirebaseFirestore.instance.collection("produtos");

    stream
        .orderBy("nome", descending: false)
        .where("idEmpresa", isEqualTo: uid)
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
    _recuperaListaProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de produtos"),
      ),
      body: Container(
          child: StreamBuilder(
        stream: _streamController.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot querySnapshot = snapshot.data;
              if (querySnapshot.docs.length == 0) {
                return Center(
                  child: Text(
                    "Sem produtos cadastrados",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              } else {
                return ListView.separated(
                    itemCount: querySnapshot.docs.length,
                    separatorBuilder: (context, indice) => Divider(
                          height: 4,
                          color: Colors.grey,
                        ),
                    // ignore: missing_return
                    itemBuilder: (context, indice) {
                      // ignore: unused_local_variable
                      List<DocumentSnapshot> listadados =
                          querySnapshot.docs.toList();
                      DocumentSnapshot dados = listadados[indice];
                      return ListTile(
                        contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                        leading: CircleAvatar(
                            backgroundImage: dados["urlImagem"] != null
                                ? NetworkImage(dados["urlImagem"])
                                : null,
                            maxRadius: 50,
                            backgroundColor: Colors.grey),
                        title: Text(dados["nome"]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Preço: R\$ " + dados["preco"]),
                            Text(dados["descricao"]),
                          ],
                        ),
                      );
                    });
              }
              break;
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/cadastroproduto");
        },
      ),
    );
  }
}
