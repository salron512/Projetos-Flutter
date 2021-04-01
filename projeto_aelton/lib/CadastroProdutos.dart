import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/Produtos.dart';

class CadastroProdutos extends StatefulWidget {
  @override
  _CadastroProdutosState createState() => _CadastroProdutosState();
}

class _CadastroProdutosState extends State<CadastroProdutos> {
  StreamController _controller = StreamController.broadcast();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerMarca = TextEditingController();

  Stream _recuperaProdutos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db
        .collection("produtos")
        .orderBy("nome", descending: false)
        .snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  _salvarProduto(String nome, String marca) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("produtos").doc().set({
      "nome": nome,
      "marca": marca,
    });
    _recuperaProdutos();
  }

  _cadastrarProdutos() async {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("cadastro de produtos"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/solicitacao.png"),
                    ),
                  ),
                  TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Nome do produto",
                    ),
                  ),
                  TextField(
                    controller: _controllerMarca,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Marca do produto",
                    ),
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controllerMarca.clear();
                  _controllerNome.clear();
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  _salvarProduto(_controllerNome.text, _controllerMarca.text);
                  Navigator.pop(context);
                  _controllerMarca.clear();
                  _controllerNome.clear();
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _editaProduto(String nome, String marca, String id) {
    setState(() {
      _controllerNome.text = nome;
      _controllerMarca.text = marca;
    });
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Dados do produtos"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/solicitacao.png"),
                    ),
                  ),
                  TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Nome do produto",
                    ),
                  ),
                  TextField(
                    controller: _controllerMarca,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Marca do produto",
                    ),
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("produtos").doc(id).update({
                    "nome": _controllerNome.text,
                    "marca": _controllerMarca.text,
                  });
                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _apagaProduto(String nome, String marca, String id) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir produtos"),
            content: Container(
              height: 250,
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
                    child: Text("Produto: " + nome),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Marca: " + marca),
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("produtos").doc(id).delete();
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
    // TODO: implement initState
    super.initState();
    _recuperaProdutos();
    _controllerNome.clear();
    _controllerMarca.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
      ),
      body: Center(
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
                    "Sem produtos cadastrados!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return ListView.separated(
                  itemCount: querySnapshot.docs.length,
                  separatorBuilder: (context, indice) => Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  itemBuilder: (context, indice) {
                    List<DocumentSnapshot> requisicoes =
                        querySnapshot.docs.toList();
                    DocumentSnapshot dados = requisicoes[indice];
                    return ListTile(
                      title: Text("Produto: " + dados["nome"]),
                      subtitle: Text("Marca: " + dados["marca"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                _editaProduto(dados["nome"], dados["marca"],
                                    dados.reference.id);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _apagaProduto(dados["nome"], dados["marca"],
                                    dados.reference.id);
                              }),
                        ],
                      ),
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
          _cadastrarProdutos();
        },
      ),
    );
  }
}
