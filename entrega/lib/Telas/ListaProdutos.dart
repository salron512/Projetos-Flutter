import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ListaProdutos extends StatefulWidget {
  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  StreamController _streamController = StreamController.broadcast();

  var _mascaraQtd = MaskTextInputFormatter(
      mask: '#########', filter: {"#": RegExp(r'[0-9]')});

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

  _editaProduto(
      String id, String nome, String descricao, String preco, int estoque) {
    TextEditingController controllerNome = TextEditingController(text: nome);
    TextEditingController controllerDescricao =
        TextEditingController(text: descricao);
    TextEditingController controllerPreco = TextEditingController(text: preco);
    TextEditingController controllerEstoque =
        TextEditingController(text: estoque.toString());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Editar informações"),
            content: Container(
                width: 200,
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Nome produto",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: controllerNome,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            prefix: Text("R\$ "),
                            hintText: "Preço",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: controllerPreco,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Descrição",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: controllerDescricao,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [_mascaraQtd],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Estoque",
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            controller: controllerEstoque),
                      ),
                    ],
                  ),
                )),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Confirmar"),
                onPressed: () {
                  _salvaAlteracaoProduto(
                    id,
                    controllerNome.text,
                    controllerDescricao.text,
                    controllerPreco.text,
                    controllerEstoque.text,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _salvaAlteracaoProduto(
      String id, String nome, String descricao, String preco, String estoque) {
    FirebaseFirestore.instance.collection("produtos").doc(id).update({
      "nome": nome,
      "descricao": descricao,
      "preco": preco,
      "estoque": int.parse(estoque).toInt()
    });
  }

  _excluirProduto(String idDoc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir produto"),
            content: Container(
              width: 150,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Confirmar exclusão?",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Confirmar"),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("produtos")
                      .doc(idDoc)
                      .delete();
                  _excluiImagem(idDoc);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _excluiImagem(String idProduto) {
    FirebaseStorage storage = FirebaseStorage.instance;
    var pastaRaiz = storage.ref();
    pastaRaiz.child("produtos").child(idProduto).listAll().then((value) {
      for (var item in value.items) {
        print("teste for: " + item.fullPath);
        pastaRaiz.child(item.fullPath).delete();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaListaProdutos();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
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
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
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
                      bool estoqueAtivo = dados['estoqueAtivo'];
                      return Container(
                          padding: EdgeInsets.all(4),
                          child: GestureDetector(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dados["urlImagem"] != null
                                    ? Container(
                                        child: Image.network(
                                          dados["urlImagem"],
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 120,
                                        ),
                                      )
                                    : Container(
                                        child: Image.asset(
                                        "images/error.png",
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 120,
                                      )),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(dados["nome"]),
                                        Text("Preço: R\$ " + dados["preco"]),
                                        Text(dados["descricao"]),
                                        dados['estoqueAtivo'] == true
                                            ? Text("Estoque " +
                                                dados['estoque'].toString())
                                            : Text(''),
                                        Row(
                                          children: [
                                            Checkbox(
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                value: estoqueAtivo,
                                                onChanged: (value) {
                                                  setState(() {
                                                    FirebaseFirestore.instance
                                                        .collection('produtos')
                                                        .doc(dados.reference.id)
                                                        .update({
                                                      'estoqueAtivo': value
                                                    });
                                                    estoqueAtivo = value;
                                                  });
                                                }),
                                            Text("Estoque ativo"),
                                          ],
                                        )
                                      ]),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _excluirProduto(dados.reference.id);
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            onLongPress: () {
                              String idDocumento = dados.reference.id;
                              Navigator.pushNamed(context, "/perfilproduto",
                                  arguments: idDocumento);
                            },
                            onTap: () {
                              _editaProduto(
                                  dados.reference.id,
                                  dados["nome"],
                                  dados["descricao"],
                                  dados["preco"],
                                  dados['estoque']);
                            },
                          ));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(

                    onPressed: () {
                      Navigator.pushNamed(context, '/grupo');
                    },
                    child: Text("Cadastrar Grupo de produtos")),
              )
            ],
          )),
    );
  }
}
