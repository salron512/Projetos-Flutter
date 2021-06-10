import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:projeto_tiago/model/Produtos.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';

class ListaCompras extends StatefulWidget {
  ListaCompras({Key key}) : super(key: key);

  @override
  _ListaComprasState createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  var _mascaraQtd = MaskTextInputFormatter(
      mask: '##########', filter: {"#": RegExp(r'[0-9]')});
  StreamController _streamController = StreamController.broadcast();
  TextEditingController _controllerQtd = TextEditingController();
  TextEditingController _controllerPrecoTotal = TextEditingController();
  TextEditingController _controllerTroco = TextEditingController();
  String _totalCompra = "0";
  bool _mostraBottomBar = false;
  double _totalCesta = 0;
  String _msgErro = "";

  _recuperaLista() async {
    String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
    List<QueryDocumentSnapshot> snapshot;
    Map<String, dynamic> dados;

    var dadosFirebase = FirebaseFirestore.instance.collection("listaPendente");

    var stream = dadosFirebase
        .doc(uid)
        .collection(uid)
        .orderBy("nome", descending: false)
        .snapshots();

    stream.listen((event) {
      if (mounted) {
        _streamController.add(event);
      }
      snapshot = event.docs;
      if (mounted) {
        setState(() {
          _totalCompra = "0";
          _totalCesta = 0;
        });
      }
      snapshot.forEach((element) async {
        Produtos produtos = Produtos();

        dados = element.data();
        print("preco total " + dados["precoTotal"]);
        produtos.id = dados["idProduto"];

        _totalCesta =
            _totalCesta + double.tryParse(dados["precoTotal"]).toDouble();
        _totalCompra = _totalCesta.toStringAsFixed(2);
        if (mounted) {
          _verificaCompra();
        }
      });
    });
  }

  _verificaCompra() {
    if (mounted) {
      if (_totalCesta > 0) {
        setState(() {
          _mostraBottomBar = true;
        });
      } else {
        setState(() {
          _mostraBottomBar = false;
        });
      }
    }
  }

  _editaProduto(String qtd, String preco, String precoTatal, String id,
      String idProduto) {
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
                    inputFormatters: [_mascaraQtd],
                    controller: _controllerQtd,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    onChanged: (valor) {
                      if (valor.isNotEmpty) {
                        double qtdProduto = double.tryParse(valor).toDouble();
                        double precoTotal = double.tryParse(preco).toDouble();
                        double resultado = precoTotal * qtdProduto;
                        setState(() {
                          _controllerPrecoTotal.text =
                              resultado.toStringAsFixed(2);
                          _msgErro = "";
                        });
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controllerQtd.clear();
                          });
                        },
                      ),
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
                onPressed: () async {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  Map<String, dynamic> dados;
                  int qtd;
                  int estoque;
                  DocumentSnapshot snapshot =
                  await db.collection("produtos").doc(idProduto).get();
                  dados = snapshot.data();
                  estoque = dados["quantidade"];

                  if (_controllerQtd.text == "0" ||
                      _controllerQtd.text.isEmpty) {
                    _mostraErro("Insira a quantidade correta");
                  } else {
                    qtd = int.parse(_controllerQtd.text).toInt();

                    if (estoque >= qtd) {
                      String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
                      db
                          .collection("listaPendente")
                          .doc(uid)
                          .collection(uid)
                          .doc(id)
                          .update({
                        "quantidade": _controllerQtd.text,
                        "precoTotal": _controllerPrecoTotal.text
                      });
                      _controllerPrecoTotal.clear();
                      _controllerQtd.clear();
                      Navigator.pop(context);
                    } else {
                      _mostraErro("Produto sem estoque");
                    }
                  }
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _verificaEstoque() async {
    // _selecionaFormaPagamento();
    String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
    bool confirmarCompra = true;

    QuerySnapshot listaCompras = await FirebaseFirestore.instance
        .collection("listaPendente")
        .doc(uid)
        .collection(uid)
        .get();

    for (var item in listaCompras.docs) {
      int estoque = 0;
      int qtdCompra = 0;
      int resultado = 0;
      Map<String, dynamic> dados = item.data();
      Map<String, dynamic> mapProduto;
      String idProduto = dados["idProduto"];
      qtdCompra = int.parse(dados["quantidade"]).toInt();
      DocumentSnapshot produto = await FirebaseFirestore.instance
          .collection("produtos")
          .doc(idProduto)
          .get();
      mapProduto = produto.data();
      estoque = mapProduto["quantidade"];
      resultado = estoque - qtdCompra;
      print("resultado " + resultado.toString());
      if (resultado < 0) {
        confirmarCompra = false;
      }
      print("contando estoque");
    }
    return confirmarCompra;
  }

  _alterarEstoque(String idProtudo, int qtdCompra) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String, dynamic> mapProduto;
    int estoque = 0;

    DocumentSnapshot produto = await FirebaseFirestore.instance
        .collection("produtos")
        .doc(idProtudo)
        .get();
    mapProduto = produto.data();
    estoque = mapProduto["quantidade"];
    estoque = estoque - qtdCompra;

    db.collection("produtos").doc(idProtudo).update({
      "quantidade": estoque,
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
                onPressed: () async {
                  String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  await db
                      .collection("listaPendente")
                      .doc(uid)
                      .collection(uid)
                      .doc(id)
                      .delete();
                  Navigator.pop(context);
                  _verificaCompra();
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        });
  }

  _mostraErro(String erro) {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Container(
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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

  // ignore: non_constant_identifier_names
  _selecionaFormaPagamento() {
    showDialog(
        barrierDismissible: true,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Selecione a forma de pagamento"),
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
                      child: Image.asset("images/cartao.png"),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: TextButton(
                    child: Text("Dinheiro"),
                    onPressed: () {
                      Navigator.pop(context);
                      _salvaPedido("Dinheiro");
                    },
                  )),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: TextButton(
                  child: Text("Cartão débito"),
                  onPressed: () {
                    Navigator.pop(context);
                    _salvaPedido("Cartão debito");
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: TextButton(
                    child: Text("Cartão crédito"),
                    onPressed: () {
                      Navigator.pop(context);
                      _salvaPedido("Cartão crédito");
                    },
                  ))
            ],
          );
        });
  }

  _enviaAlerta() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<String> list = [];
    var snapshot = await db
        .collection("usuarios")
        .where("entregador", isEqualTo: true)
        .get();

    for (var item in snapshot.docs) {
      Map<String, dynamic> map = item.data();
      String idUsuarioNotigicacao = map["playerId"];
      list.add(idUsuarioNotigicacao);
    }
    //sempre que o content for alterado deve-se alterar o metodo _recebeNot
    // que está no arquivo ListaCategorias.dart
    OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: list,
      heading: "Nova entrega",
      content: "Você tem uma nova entrega!",
    ));
  }

  _salvaPedido(String formaPagamento) {
    if (formaPagamento == "Dinheiro") {
      showDialog(
          barrierDismissible: false,
          context: context,
          // ignore: missing_return
          builder: (context) {
            return AlertDialog(
              title: Text("Finalizar compra"),
              content: Container(
                width: 100,
                height: 300,
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text("Total compra: " + _totalCompra),
                    ),
                    TextField(
                      controller: _controllerTroco,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Digite o troco",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _controllerTroco.clear();
                    },
                    child: Text("Cancelar")),
                TextButton(
                  onPressed: () async {
                    if (_controllerTroco.text.contains(",")) {
                      _mostraErro("O uso de virgula não é inválido");
                    } else {
                      bool confirmarCompra = await  _verificaEstoque();
                      if (confirmarCompra) {
                        if (_controllerTroco.text.isNotEmpty) {
                          double totalCompra =
                          double.tryParse(_totalCompra).toDouble();
                          double troco =
                          double.tryParse(_controllerTroco.text).toDouble();
                          String trocoSalvar = "0";
                          double trocoFinal = troco - totalCompra;
                          trocoSalvar = trocoFinal.toStringAsFixed(2);
                          print("troco " + trocoFinal.toString());
                          print("totalCompra " + totalCompra.toString());
                          if (trocoFinal >= 0) {
                            FirebaseFirestore db = FirebaseFirestore.instance;
                            String uid =
                            RecuperaDadosFirebase.RECUPERAUSUARIO();
                            var dadosUsuario =
                            await db.collection("usuarios").doc(uid).get();
                            Map<String, dynamic> mapUsuario =
                            dadosUsuario.data();

                            var snap = db
                                .collection("listaPendente")
                                .doc(uid)
                                .collection(uid)
                                .orderBy("nome", descending: false)
                                .get();
                            snap.then((event) {
                              List<dynamic> listaCompras = [];
                              for (var item in event.docs) {
                                Map<String, dynamic> map = item.data();
                                listaCompras.add(map);
                                String idProduto = map["idProduto"];
                                int qtdCompra =
                                int.parse(map["quantidade"]).toInt();

                                _alterarEstoque(idProduto, qtdCompra);
                              }

                              db.collection("listaCompra").doc().set({
                                "dataCompra": DateTime.now().toString(),
                                "status": "Pendente",
                                "nome": mapUsuario["nome"],
                                "telefone": mapUsuario["telefone"],
                                "whatsapp": mapUsuario["whatsapp"],
                                "endereco": mapUsuario["endereco"],
                                "cidade": mapUsuario["cidade"],
                                "bairro": mapUsuario["bairro"],
                                "prontoReferencia":
                                mapUsuario["pontoReferencia"],
                                "idUsuario": uid,
                                "listaProdutos": listaCompras,
                                "totalCompra": _totalCompra,
                                "formaPagamento": formaPagamento,
                                "troco": trocoSalvar,
                                "entrega": "pendente"
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
                                  _enviaAlerta();
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, "/listacategorias");
                                });
                              });
                            });
                          } else {
                            _mostraErro("Troco inválido");
                          }
                        } else {
                          _mostraErro("Troco inválido");
                        }
                      } else {
                        _mostraErro(
                            "Existe algum produto sem estoque na sua compra, por favor refaça a compra");
                      }
                    }
                  },
                  child: Text("Confirmar"),
                ),
              ],
            );
          });
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          // ignore: missing_return
          builder: (context) {
            return AlertDialog(
              title: Text("Finalizar compra"),
              content: Container(
                width: 100,
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
                TextButton(
                  onPressed: () async {
                    FirebaseFirestore db = FirebaseFirestore.instance;
                    String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
                    var dadosUsuario =
                    await db.collection("usuarios").doc(uid).get();
                    Map<String, dynamic> mapUsuario = dadosUsuario.data();
                    bool confirmaCompra = await _verificaEstoque();
                    if (confirmaCompra) {
                      var snap = db
                          .collection("listaPendente")
                          .doc(uid)
                          .collection(uid)
                          .orderBy("nome", descending: false)
                          .get();
                      snap.then((event) {
                        List<dynamic> listaCompras = [];
                        for (var item in event.docs) {
                          Map<String, dynamic> map = item.data();
                          listaCompras.add(map);
                          String idProduto = map["idProduto"];
                          int qtdCompra = int.parse(map["quantidade"]).toInt();

                          _alterarEstoque(idProduto, qtdCompra);
                        }
                        db.collection("listaCompra").doc().set({
                          "dataCompra": DateTime.now().toString(),
                          "status": "Pendente",
                          "nome": mapUsuario["nome"],
                          "telefone": mapUsuario["telefone"],
                          "whatsapp": mapUsuario["whatsapp"],
                          "endereco": mapUsuario["endereco"],
                          "cidade": mapUsuario["cidade"],
                          "bairro": mapUsuario["bairro"],
                          "prontoReferencia": mapUsuario["pontoReferencia"],
                          "idUsuario": uid,
                          "listaProdutos": listaCompras,
                          "totalCompra": _totalCompra,
                          "formaPagamento": formaPagamento,
                          "troco": "0",
                          "entrega": "pendente"
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
                      _enviaAlerta();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/listacategorias");
                    } else {
                      _mostraErro(
                          "Existe algum produto sem estoque na sua compra, por favor refaça a compra");
                    }
                  },
                  child: Text("Confirmar"),
                ),
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    if (_streamController.isClosed) {
      print("teste dispose");
    } else {
      print("teste deu errado");
    }
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
                          if (querySnapshot.docs.length == 0 || snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Sem produtos",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: querySnapshot.docs.length,
                              itemBuilder: (context, indice) {
                                List<DocumentSnapshot> listaDoc =
                                querySnapshot.docs.toList();
                                DocumentSnapshot dados = listaDoc[indice];

                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  secondaryActions: [
                                    IconSlideAction(
                                      caption: "Editar",
                                      color: Colors.green,
                                      icon: Icons.edit,
                                      onTap: () => _editaProduto(
                                          dados["quantidade"],
                                          dados["precoUnitario"],
                                          dados["precoTotal"],
                                          dados.reference.id,
                                          dados["idProduto"]),
                                    ),
                                    IconSlideAction(
                                        caption: "Excluir",
                                        color: Theme.of(context).primaryColor,
                                        icon: Icons.delete,
                                        onTap: () =>
                                            _apagaProduto(dados.reference.id))
                                  ],
                                  child: Card(
                                      elevation: 8,
                                      child: ListTile(
                                        leading: Image.network(
                                          dados["urlImagem"],
                                          width: 50,
                                          height: 80,
                                        ),
                                        title: Text(dados["nome"]),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text("Marca: " + dados["marca"]),
                                            Text("Quantidade: " +
                                                dados["quantidade"]),
                                            Text("Preço unit: R\$ " +
                                                dados["precoUnitario"]),
                                            Text("Preço total: R\$ " +
                                                dados["precoTotal"]),
                                          ],
                                        ),
                                      )),
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
                            _selecionaFormaPagamento();
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