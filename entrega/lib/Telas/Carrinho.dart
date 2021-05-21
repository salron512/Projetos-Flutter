import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  var _mascaraQtd = MaskTextInputFormatter(
      mask: '#########', filter: {"#": RegExp(r'[0-9]')});
  StreamController _streamController = StreamController.broadcast();
  double _taxa = 6;
  double _totalSoma = 0;
  String _totalCompra = "0";
  bool _mostraTotal = false;
  String _idEmpresa;
  List<dynamic> _listaCompras = [];

  _recuperaCesta() {
    double soma = 0;
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference ref = FirebaseFirestore.instance.collection("cesta");

    ref.where("idUsuario", isEqualTo: uid).snapshots().listen((event) {
      if (mounted) {
        if (_listaCompras.isNotEmpty) {
          _listaCompras.clear();
        }
        _streamController.add(event);
        soma = 0;
        _totalSoma = 0;
        for (var item in event.docs) {
          Map<String, dynamic> dados = item.data();
          soma = dados["precoTotal"];
          _idEmpresa = dados["idEmpresa"];
          _listaCompras.add(dados);
          _totalSoma = _totalSoma + soma;
          print("Empresa ID" + _idEmpresa);
        }
        if (_totalSoma > _taxa) {
          setState(() {
            _mostraTotal = true;
          });
        } else {
          setState(() {
            _mostraTotal = false;
            _totalSoma = 0;
            print("executado");
          });
        }
        _totalSoma = _totalSoma + _taxa;
        setState(() {
          _totalCompra = _totalSoma.toStringAsFixed(2);
        });
      }
    });
  }

  _editaProduto(String idProduto, String nome, String qtd, double preco) {
    TextEditingController controllerQtd = TextEditingController(text: qtd);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Editar quantidade"),
            content: Container(
              height: 230,
              child: Column(
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      child: Image.asset("images/scart.png")),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(nome),
                  ),
                  TextField(
                    inputFormatters: [_mascaraQtd],
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      suffix: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          controllerQtd.clear();
                        },
                      ),
                      //contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Digite a quantidade",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: controllerQtd,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    if (controllerQtd.text.isNotEmpty) {
                      int qtd = int.parse(controllerQtd.text).toInt();
                      double vlrTotal = preco * qtd;
                      if (qtd > 0) {
                        FirebaseFirestore.instance
                            .collection("cesta")
                            .doc(idProduto)
                            .update({"qtd": qtd, "precoTotal": vlrTotal});
                        Navigator.pop(context);
                      } else {
                        _alertErro("Quantidade inválida");
                      }
                    } else {
                      _alertErro("Quantidade inválida");
                    }
                  },
                  child: Text("Confirmar"))
            ],
          );
        });
  }

  _alertErro(String erro) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Image.asset("images/error.png"),
                  ),
                  Text(
                    erro,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Confirmar"))
            ],
          );
        });
  }

  _excluirProduto(String idProduto, String nome) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir produto"),
            content: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Image.asset("images/error.png"),
                  ),
                  Text(
                    "Confirmar exclusão?",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(nome)
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("cesta")
                        .doc(idProduto)
                        .delete();
                    Navigator.pop(context);
                  },
                  child: Text("Confirmar"))
            ],
          );
        });
  }

  _confirmaPagamento(String formaPagamento) {
    switch (formaPagamento) {
      case "Dinheiro":
        TextEditingController controllerTroco = TextEditingController();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Dinheiro"),
                content: Container(
                  height: 100,
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Digite o troco",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: controllerTroco,
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
                      onPressed: () {
                        if (controllerTroco.text.isNotEmpty) {
                          if (controllerTroco.text.contains(",")) {
                            _alertErro("Uso de vírgula não é inválido");
                          } else {
                            double troco =
                                double.parse(controllerTroco.text).toDouble();
                            double resultado = troco - _totalSoma;
                            if (resultado < 0) {
                              _alertErro("Troco inválido");
                            } else {
                              Navigator.pop(context);
                              _salvaPedido(formaPagamento, troco: resultado);
                            }
                          }
                        } else {
                          _alertErro("Digite o troco");
                        }
                      },
                      child: Text("Confirmar"))
                ],
              );
            });
        break;

      case "Cartão débito":
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Cartão débito"),
                content: Container(
                  height: 100,
                  child: Column(
                    children: [Text("Forma de pagamento: " + formaPagamento)],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _salvaPedido(formaPagamento, troco: 0);
                      },
                      child: Text("Confirmar"))
                ],
              );
            });
        break;

      case "Cartão crédito":
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Cartão crédito"),
                content: Container(
                  height: 100,
                  child: Column(
                    children: [Text("Forma de pagamento: " + formaPagamento)],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _salvaPedido(formaPagamento, troco: 0);
                      },
                      child: Text("Confirmar"))
                ],
              );
            });
        break;
    }
  }

  _salvaPedido(String formaPagamento, {double troco}) async {
    if (troco < 0) {
      _aguardandoFirebase();
      String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
      Map<String, dynamic> mapUsuario;
      Map<String, dynamic> mapEmpresa;
      DocumentSnapshot dadosUsuario = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .get();
      mapUsuario = dadosUsuario.data();

      DocumentSnapshot dadosEmpresa = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(_idEmpresa)
          .get();
      mapEmpresa = dadosEmpresa.data();

      await FirebaseFirestore.instance.collection("pedidos").doc().set({
        "status": "Aguardando",
        "idEmpresa": _idEmpresa,
        "nomeEmpresa": mapEmpresa["nomeFantasia"],
        "idUsuario": uid,
        "cliente": mapUsuario["nome"],
        "telefoneUsuario": mapUsuario["telefone"],
        "whatasappUsuario": mapUsuario["whatsapp"],
        "enderecoUsuario": mapUsuario["endereco"],
        "bairroUsuario": mapUsuario["bairro"],
        "listaPedido": _listaCompras,
        "totalPedido": _totalCompra,
        "formaPagamento": formaPagamento,
        "troco": "sem troco",
      }).then((value) async {
        QuerySnapshot cestaCompras = await FirebaseFirestore.instance
            .collection("cesta")
            .where("idUsuario", isEqualTo: uid)
            .get();
        cestaCompras.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection("cesta")
              .doc(element.reference.id)
              .delete();
        });

        Navigator.pop(context);
        _confirmaPedido();
      }).catchError((erro) {
        Navigator.pop(context);
        _alertErro("Erro ao enviar seu pedido");
      });
    } else {
      String verificaTroco = troco.toStringAsFixed(2);
      _aguardandoFirebase();
      String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
      Map<String, dynamic> mapUsuario;
      Map<String, dynamic> mapEmpresa;

      DocumentSnapshot dadosUsuario = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .get();
      mapUsuario = dadosUsuario.data();

      DocumentSnapshot dadosEmpresa = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(_idEmpresa)
          .get();
      mapEmpresa = dadosEmpresa.data();

      await FirebaseFirestore.instance.collection("pedidos").doc().set({
        "status": "Aguardando",
        "idEmpresa": _idEmpresa,
        "nomeEmpresa": mapEmpresa["nomeFantasia"],
        "idUsuario": uid,
        "cliente": mapUsuario["nome"],
        "telefoneUsuario": mapUsuario["telefone"],
        "whatasappUsuario": mapUsuario["whatsapp"],
        "enderecoUsuario": mapUsuario["endereco"],
        "bairroUsuario": mapUsuario["bairro"],
        "listaPedido": _listaCompras,
        "totalPedido": _totalCompra,
        "formaPagamento": formaPagamento,
        "troco": verificaTroco,
      }).then((value) async {
        QuerySnapshot cestaCompras = await FirebaseFirestore.instance
            .collection("cesta")
            .where("idUsuario", isEqualTo: uid)
            .get();
        cestaCompras.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection("cesta")
              .doc(element.reference.id)
              .delete();
        });

        Navigator.pop(context);
        _confirmaPedido();
      }).catchError((erro) {
        Navigator.pop(context);
        _alertErro("Erro ao enviar seu pedido");
      });
    }
  }

  _aguardandoFirebase() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enviando seu pedido..."),
            content: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  _confirmaPedido() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Pedido recebido"),
            content: Container(
                height: 150,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.asset("images/food-delivery.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("Logo você receberá seu pedido"),
                    )
                  ],
                )),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Confirmar"))
            ],
          );
        });
  }

  _selecionaPagamentoAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selecione a forma de pagamento"),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                        "images/pagamento-com-cartao-de-credito.png"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmaPagamento("Dinheiro");
                  },
                  child: Text("Dinheiro")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmaPagamento("Cartão débito");
                  },
                  child: Text("Cartão débito")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmaPagamento("Cartão crédito");
                  },
                  child: Text("Cartão crédito"))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaCesta();
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
        title: Text("Carinho de compras"),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 5),
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
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot = snapshot.data;
                    if (querySnapshot.docs.length == 0) {
                      return Center(
                        child: Text(
                          "Sem produtos",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        // ignore: missing_return
                        itemBuilder: (context, indice) {
                          List<DocumentSnapshot> listaProdutos =
                              querySnapshot.docs.toList();
                          DocumentSnapshot produto = listaProdutos[indice];
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Card(
                              elevation: 8,
                              child: ListTile(
                                title: Text(
                                  produto["produto"],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Quantidade: " +
                                          produto["qtd"].toString(),
                                    ),
                                    Text(
                                      "Valor unitario: " +
                                          produto["precoUnitario"].toString(),
                                    ),
                                    Text(
                                      "Valor total: " +
                                          produto["precoTotal"].toString(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            secondaryActions: [
                              IconSlideAction(
                                caption: "Editar",
                                color: Colors.green,
                                icon: Icons.edit,
                                onTap: () => _editaProduto(
                                    produto.reference.id,
                                    produto["produto"],
                                    produto["qtd"].toString(),
                                    produto["precoUnitario"]),
                              ),
                              IconSlideAction(
                                caption: "Excluir",
                                color: Theme.of(context).primaryColor,
                                icon: Icons.delete,
                                onTap: () {
                                  _excluirProduto(
                                      produto.reference.id, produto["produto"]);
                                },
                              )
                            ],
                          );
                        },
                      );
                    }
                    break;
                }
              },
            )),
            Visibility(
                visible: _mostraTotal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: Theme.of(context).primaryColor,
                      child: ListTile(
                          title: Text(
                            "Total compra",
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Taxa de entrega R\$  " +
                                    _taxa.toStringAsFixed(2),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Valor total R\$  " + _totalCompra,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                        child: Text(
                          "Confirmar pedido",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          _selecionaPagamentoAlert();
                        },
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
