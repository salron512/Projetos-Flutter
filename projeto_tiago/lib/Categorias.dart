import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  StreamController _controller = StreamController.broadcast();
  TextEditingController _controllerNome = TextEditingController();

  // ignore: missing_return
  Stream _recuperaCategorias() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db
        .collection("categorias")
        .orderBy("categoria", descending: false)
        .snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  _editaCategoria(String nome, String id) {
      _controllerNome.text = nome;
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Editar categoria"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _controllerNome,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Nome da categoria",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controllerNome.clear();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("categorias").doc(id).update({
                    "categoria": _controllerNome.text,
                  });
                  Navigator.pop(context);
                  _controllerNome.clear();
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _apagaCategoria(String nome, String id) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir categoria"),
            content: Container(
              height: 190,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/excluir.png"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Categoria: " + nome),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  FirebaseStorage storage = FirebaseStorage.instance;
                  var pastaRaiz = storage.ref();
                  pastaRaiz
                      .child("categorias")
                      .child(id)
                      .listAll()
                      .then((value) {
                    for (var item in value.items) {
                      pastaRaiz.child(item.fullPath).delete();
                    }
                  });

                  db.collection("categorias").doc(id).delete();
                  db.collection("galeria").doc(id).delete();

                  Navigator.pop(context);
                },
                child: Text("Deletar"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaCategorias();
    _controllerNome.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          //padding: EdgeInsets.all(16),
          child: StreamBuilder(
            stream: _controller.stream,
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  QuerySnapshot querySnapshot = snapshot.data;
                  if (querySnapshot.docs.length == 0) {
                    return Center(
                      child: Text(
                        "Sem categorias cadastradas!",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    );
                  } else {
                    return ListView.separated(
                      itemCount: querySnapshot.docs.length,
                      separatorBuilder: (context, indice) => Divider(
                        height: 4,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context, indice) {
                        List<DocumentSnapshot> listaDados =
                            querySnapshot.docs.toList();
                        DocumentSnapshot dados = listaDados[indice];
                        return ListTile(
                          leading: dados["urlImagem"] == null
                              ? Image.asset("images/gear.png")
                              : Image.network(dados["urlImagem"]),
                          title: Text(
                            "Produto: " + dados["categoria"],
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    _editaCategoria(
                                        dados["categoria"], dados.reference.id);
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _apagaCategoria(
                                        dados["categoria"], dados.reference.id);
                                  }),
                            ],
                          ),
                   
                          onTap: () {
                            Navigator.pushNamed(context, "/perfilcategoria",arguments: dados.reference.id);
                          },
                   
                        );
                      },
                    );
                  }
                  break;
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xffFF0000),
        onPressed: () {
          // _cadastrarProdutos();
          Navigator.pushNamed(context, "/cadastracategorias");
        },
      ),
    );
  }
}
