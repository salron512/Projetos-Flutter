import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CadastroProdutos extends StatefulWidget {
  @override
  _CadastroProdutosState createState() => _CadastroProdutosState();
}

class _CadastroProdutosState extends State<CadastroProdutos> {
  StreamController _controller = StreamController.broadcast();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerMarca = TextEditingController();
  TextEditingController _controllerPreco = TextEditingController();

  // ignore: missing_return
  Stream _recuperaProdutos() {
    var stream = FirebaseFirestore.instance.collection("produtos");

    stream.orderBy("nome", descending: false).snapshots().listen((event) {
      if (mounted) {
        _controller.add(event);
      }
    });
  }

  _editaProduto(String nome, String marca, String preco, String id) {
    setState(() {
      _controllerNome.text = nome;
      _controllerMarca.text = marca;
      _controllerPreco.text = preco;
    });
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Editar produtos"),
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
                      labelText: "Nome do produto",
                    ),
                  ),
                  TextField(
                    controller: _controllerMarca,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Marca do produto",
                    ),
                  ),
                  TextField(
                    controller: _controllerPreco,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: Text("R\$ "),
                      labelText: "Preço",
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controllerNome.clear();
                  _controllerMarca..clear();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("produtos").doc(id).update({
                    "nome": _controllerNome.text,
                    "marca": _controllerMarca.text,
                    "preco": _controllerPreco.text,
                  });
                  Navigator.pop(context);
                  _controllerNome.clear();
                  _controllerMarca..clear();
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _selecaoGaleriaPerfil(String dados) {
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
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Mudar categoria"),
                onPressed: () {
                  Navigator.pop(context);
                  _recuperalistaCategorias(dados);
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/grid", arguments: dados);
                },
                child: Text("Perfil"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/gridproduto",
                      arguments: dados);
                },
                child: Text("Galeria"),
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
                    child: Text("Produto: " + nome),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Marca: " + marca),
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
                  pastaRaiz.child("produtos").child(id).listAll().then((value) {
                    for (var item in value.items) {
                      print("teste for: " + item.fullPath);
                      pastaRaiz.child(item.fullPath).delete();
                    }
                  });

                  db.collection("produtos").doc(id).delete();
                  db
                      .collection("galeria")
                      .doc(id)
                      .collection(id)
                      .get()
                      .then((value) {
                    value.docs.forEach((element) {
                      db
                          .collection("galeria")
                          .doc(id)
                          .collection(id)
                          .doc(element.id)
                          .delete();
                    });
                  });
                  Navigator.pop(context);
                },
                child: Text("Deletar"),
              ),
            ],
          );
        });
  }

  _alteraCategoria(String idDocumento, String categoria) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("produtos").doc(idDocumento).update({
      "categoria": categoria,
    });
    Navigator.pop(context);
  }

  _recuperalistaCategorias(String idDocumento) async {
    List listaCategorias = [];
    CollectionReference query =
        FirebaseFirestore.instance.collection("categorias");
    QuerySnapshot doc = await query.orderBy("categoria").get();
    for (var item in doc.docs) {
      Map<String, dynamic> dados = item.data();
      listaCategorias.add(dados["categoria"]);
    }
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir produtos"),
            content: Container(
                height: 250,
                child: ListView.separated(
                  itemCount: listaCategorias.length,
                  separatorBuilder: (context, indice) => Divider(
                    height: 4,
                    color: Colors.grey,
                  ),
                  // ignore: missing_return
                  itemBuilder: (context, indice) {
                    var dados = listaCategorias[indice];
                    return ListTile(
                      title: Text(dados),
                      onTap: () {
                        _alteraCategoria(idDocumento,dados);
                      },
                    );
                  },
                )),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaProdutos();
    _controllerNome.clear();
    _controllerMarca.clear();
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
                        "Sem produtos cadastrados!",
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
                            "Produto: " + dados["nome"],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Marca: " + dados["marca"],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Categoria: " + dados["categoria"],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Preço: " + "R\$ " + dados["preco"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
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
                                    _editaProduto(dados["nome"], dados["marca"],
                                        dados["preco"], dados.reference.id);
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
                          onTap: () {
                            _selecaoGaleriaPerfil(dados.reference.id);
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
          Navigator.pushNamed(context, "/produto");
        },
      ),
    );
  }
}
