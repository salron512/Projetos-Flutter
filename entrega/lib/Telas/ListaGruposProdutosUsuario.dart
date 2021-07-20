import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:entrega/util/RecupepraFirebase.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListaGruposProdutosUsuario extends StatefulWidget {
  var idEmpresa;
  ListaGruposProdutosUsuario(this.idEmpresa);
  @override
  _ListaGruposProdutosUsuarioState createState() =>
      _ListaGruposProdutosUsuarioState();
}

class _ListaGruposProdutosUsuarioState
    extends State<ListaGruposProdutosUsuario> {
  StreamController _streamContorller = StreamController.broadcast();
  String _tipoUsuario = '';
  String _idEmpresa;

  _recuperaGrupos() {
    _idEmpresa = widget.idEmpresa;

    CollectionReference reference =
        FirebaseFirestore.instance.collection("grupoProduto");

    reference
       // .orderBy("nome", descending: true)
        .where("idEmpresa", isEqualTo: _idEmpresa)
        .snapshots()
        .listen((event) {
      if (mounted) {
        _streamContorller.add(event);
      }
    });
  }

  _recuperaUsuario() async {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    var dadosFirebase =
        await FirebaseFirestore.instance.collection("usuarios").doc(uid).get();
    Map<String, dynamic> dadosUsuario = dadosFirebase.data();

    _tipoUsuario = dadosUsuario["tipoUsuario"];
  }

  @override
  void initState() {
    super.initState();
    _recuperaUsuario();
    _recuperaGrupos();
  }

  @override
  void dispose() {
    super.dispose();
    _streamContorller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _streamContorller.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot querySnapshot = snapshot.data;
                if (querySnapshot.docs.length == 0) {
                  return Center(child: Text("Sem opções para essa categoria"));
                } else {
                  return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, indice) {
                        List<QueryDocumentSnapshot> listGrupo =
                            querySnapshot.docs.toList();
                        QueryDocumentSnapshot grupo = listGrupo[indice];
                        return Card(
                          elevation: 8,
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: Text(
                              grupo["nome"],
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, "/listaprodutosusuario",
                                  arguments: grupo);
                            },
                          ),
                        );
                      });
                }
                break;
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          if (_tipoUsuario != "empresa") {
            Navigator.pushNamed(context, "/carinho", arguments: _idEmpresa);
          }
        },
      ),
    );
  }
}
