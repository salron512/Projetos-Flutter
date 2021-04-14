import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db
        .collection("produtos")
        .orderBy("nome", descending: false)
        .snapshots();
    stream.listen((event) {
      _controller.add(event);
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
        child: Center(
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
                      height: 2,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context, indice) {
                      List<DocumentSnapshot> requisicoes =
                          querySnapshot.docs.toList();
                      DocumentSnapshot dados = requisicoes[indice];
                      return ListTile(
                        leading: Image.asset("images/user.png"),
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
      ),
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
