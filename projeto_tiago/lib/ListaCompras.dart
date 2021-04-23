import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';

class ListaCompras extends StatefulWidget {
  ListaCompras({Key key}) : super(key: key);

  @override
  _ListaComprasState createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  StreamController _streamController = StreamController.broadcast();
  TextEditingController _controllerQtd = TextEditingController();
  TextEditingController _controllerPrecoTotal = TextEditingController();
  String _totalCompra = "0";
  bool _mostraBottomBar = false;
  double _totalCesta = 0;
  String _msgErro = "";

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
      _totalCompra = "0";
      _totalCesta = 0;
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
      if (_totalCesta > 0) {
        setState(() {
          _mostraBottomBar = true;
        });
      }
    });
  }

  _editaProduto(String qtd, String preco, String precoTatal, String id) {
    setState(() {
      _controllerQtd.text = qtd;
      _controllerPrecoTotal.text = precoTatal;
    });
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Editar quantidade"),
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
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  TextField(
                    controller: _controllerQtd,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    onChanged: (valor) {
                      if (valor != "0" || valor.isNotEmpty || valor != null) {
                        //  _totalCesta = 0;
                        //_totalCompra = "0";
                        double qtdProduto = double.tryParse(valor).toDouble();
                        double precoTotal = double.tryParse(preco).toDouble();
                        double resultado = precoTotal * qtdProduto;
                        setState(() {
                          _controllerPrecoTotal.text = resultado.toString();
                          _msgErro = "";
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Quantidade do produto",
                    ),
                  ),
                  TextField(
                    controller: _controllerPrecoTotal,
                    readOnly: true,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: Text("R\$ "),
                      labelText: "Preço total",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _msgErro,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controllerPrecoTotal.clear();
                  _controllerQtd.clear();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  if (_controllerQtd.text == "0" ||
                      _controllerQtd.text.isEmpty) {
                    _mostraErro("Insira a quantidade correta");
                  } else {
                    String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
                    FirebaseFirestore db = FirebaseFirestore.instance;
                    db
                        .collection("listaPendente")
                        .doc(uid)
                        .collection(uid)
                        .doc(id)
                        .update({
                      "quantidade": _controllerQtd.text,
                      "precoTotal": _controllerPrecoTotal.text
                    });
                    Navigator.pop(context);
                    _controllerPrecoTotal.clear();
                    _controllerQtd.clear();
                  }
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _apagaProduto(String id) {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir produtos"),
            content: Container(
              height: 120,
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
                  String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db
                      .collection("listaPendente")
                      .doc(uid)
                      .collection(uid)
                      .doc(id)
                      .delete();

                  Navigator.pop(context);
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        });
  }

  _mostraErro(String erro) {
    setState(() {});
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Container(
              width: 150,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/error.png"),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        erro,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        });
  }

  _salvaPedido() {
    setState(() {});
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Finalizar compra"),
            content: Container(
              width: 150,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Confirmar compra?",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
                  Map<String, dynamic> map;
                  List<QueryDocumentSnapshot> query = [];
                  var stream = db
                      .collection("listaPendente")
                      .doc(uid)
                      .collection(uid)
                      .orderBy("nome", descending: false)
                      .get();

                  stream.then((event) {
                    List<dynamic> listaCompras = [];
                    for (var item in event.docs) {
                      Map<String, dynamic> map = item.data();
                      listaCompras.add(map);
                    }

                    db.collection("listaCompra").doc().set({
                      "dataCompra": DateTime.now().toString(),
                      "idUsuario": uid,
                      "listaProdutos": listaCompras,
                    }).then((value) {
                      db
                          .collection("listaPendente")
                          .doc(uid)
                          .collection(uid)
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          db
                              .collection("listaPendente")
                              .doc(uid)
                              .collection(uid)
                              .doc(element.reference.id)
                              .delete()
                              .then((value) {
                            setState(() {
                              _totalCompra = "0";
                            });
                          });
                        });
                      });
                    });
                  });
                  setState(() {
                    _totalCompra = "0";
                  });

                  Navigator.pop(context);
                },
                child: Text("Confirmar"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"))
            ],
          );
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
          padding: EdgeInsets.only(left: 5, right: 5),
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
                                elevation: 8,
                                child: ListTile(
                                  leading: Image.network(
                                    dados["urlimagem"],
                                    width: 50,
                                    height: 80,
                                  ),
                                  title: Text(dados["nome"]),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Marca: " + dados["marca"]),
                                      Text(
                                          "Quantidade: " + dados["quantidade"]),
                                      Text("Preço unit R\$: " +
                                          dados["precoUnitario"]),
                                      Text("Preço total R\$: " +
                                          dados["precoTotal"]),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32))),
                                              child: Text("Editar"),
                                              onPressed: () {
                                                _editaProduto(
                                                    dados["quantidade"],
                                                    dados["precoUnitario"],
                                                    dados["precoTotal"],
                                                    dados.reference.id);
                                              }),
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Theme.of(context)
                                                        .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        32))),
                                                child: Text("Excluir"),
                                                onPressed: () {
                                                  _apagaProduto(
                                                      dados.reference.id);
                                                }),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ));
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
                child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
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
                          onPressed: () {
                            _salvaPedido();
                          },
                        )
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
