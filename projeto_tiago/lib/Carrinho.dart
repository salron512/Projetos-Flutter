import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';

// ignore: must_be_immutable
class Carrinho extends StatefulWidget {
  String categoria;
  Carrinho(this.categoria);
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  // ignore: unused_field
  String _nomeAppBar = " Produtos";
  var _mascaraQtd = MaskTextInputFormatter(
      mask: '##########', filter: {"#": RegExp(r'[0-9]')});
  StreamController _controller = StreamController.broadcast();
  TextEditingController _controllerQtd = TextEditingController();
  TextEditingController _controllerResultado = TextEditingController(text: "0");

  _recebeNomeAppBar() {
    setState(() {
      _nomeAppBar = widget.categoria;
    });
  }

  _recuperaProdutos() {
    String categoria = widget.categoria;
    var stream = FirebaseFirestore.instance.collection("produtos");

    stream
        .where("quantidade", isGreaterThan: 0)
        //.orderBy("nome", descending: false)
        .where("categoria", isEqualTo: categoria)
        .snapshots()
        .listen((event) {
      if (mounted) {
        _controller.add(event);
      }
    });
  }

  _addItem(String idProduto, String nome, String marca, String preco,
      String urlImagem, int estoque) {
    String precoTotal = preco;
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Digite a quantidade"),
            content: Container(
              height: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Produto: " + nome,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Valor unitário R\$ " + preco,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Quantidade disponível: " + estoque.toString() + " und",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    autofocus: true,
                    controller: _controllerQtd,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_mascaraQtd],
                    decoration: InputDecoration(
                        labelText: "Digite a quantidade",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controllerQtd.clear();
                            });
                          },
                        )),
                    onChanged: (valor) {
                      if (valor.isNotEmpty) {
                        String valorSemMascara = _mascaraQtd.unmaskText(valor);
                        print("valor" + valor);
                        double precoCompra = double.tryParse(preco).toDouble();
                        double qtdcoCompra =
                            double.tryParse(valorSemMascara).toDouble();
                        double resultado = precoCompra * qtdcoCompra;
                        print("res" + resultado.toString());
                        precoTotal = resultado.toStringAsFixed(2);
                        setState(() {
                          _controllerResultado.text = precoTotal;
                        });
                      }
                    },
                  ),
                  TextField(
                      readOnly: true,
                      controller: _controllerResultado,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Valor total", prefix: Text("R\$ "))),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _controllerResultado.clear();
                    _controllerQtd.clear();
                  },
                  child: Text("Cancelar")),
              TextButton(
                  child: Text("Confirmar"),
                  onPressed: () async {
                    if (_controllerQtd.text.isNotEmpty) {
                      int qtd = 0;
                      qtd = int.tryParse(_controllerQtd.text).toInt();
                      if (estoque >= qtd) {
                        if (qtd > 0 || _controllerQtd.text.isEmpty) {
                          FirebaseFirestore db = FirebaseFirestore.instance;
                          String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();

                          db
                              .collection("listaPendente")
                              .doc(uid)
                              .collection(uid)
                              .doc()
                              .set({
                            "idProduto": idProduto,
                            "idUsuario": uid,
                            "nome": nome,
                            "marca": marca,
                            "quantidade": _controllerQtd.text,
                            "precoUnitario": preco,
                            "precoTotal": precoTotal,
                            "urlimagem": urlImagem,
                          });
                          _controllerQtd.clear();
                          _controllerResultado.clear();
                          Navigator.pop(context);
                        } else {
                          _alertErro();
                        }
                      } else {
                        _alertErro();
                      }
                    } else {
                      _alertErro();
                    }
                  }),
            ],
          );
        });
  }

  _alertErro() {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Erro"),
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Image.asset("images/error.png"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Quantidade inválida",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _controllerResultado.clear();
                    _controllerQtd.clear();
                  },
                  child: Text("Confirmar")),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recebeNomeAppBar();
    _recuperaProdutos();
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
        padding: EdgeInsets.all(5),
        child: StreamBuilder(
          stream: _controller.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text("Sem conexão"),
                );
                break;
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
                    child: Text(
                      "Sem produtos cadastrados",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  );
                } else {
                  return GridView.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    children: List.generate(
                        // ignore: missing_return
                        querySnapshot.docs.length, (indice) {
                      List<DocumentSnapshot> urls = querySnapshot.docs.toList();
                      DocumentSnapshot dados = urls[indice];
                      // ignore: missing_required_param
                      return PhysicalModel(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.white,
                          elevation: 8,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 50,
                                  child: dados["urlImagem"] == null
                                      ? Center(
                                          child: Text("produto sem imagem"),
                                        )
                                      : Image.network(
                                          dados["urlImagem"],
                                        ),
                                ),
                                Expanded(
                                  flex: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, left: 15),
                                        child: Text(
                                          dados["nome"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, left: 15),
                                        child: Text(
                                          "Marca: " + dados["marca"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, left: 15),
                                        child: Text(
                                          "R\$ " + dados["preco"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, left: 15),
                                        child: Text(
                                          "Quantidade disponível: " +
                                              dados["quantidade"].toString() +
                                              " und",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, left: 5),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        32))),
                                                child: Text("Imagens"),
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, "/gridproduto",
                                                      arguments:
                                                          dados.reference.id);
                                                }),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, left: 32),
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
                                                child: Text("Comprar"),
                                                onPressed: () {
                                                  _addItem(
                                                      dados.reference.id,
                                                      dados["nome"],
                                                      dados["marca"],
                                                      dados["preco"],
                                                      dados["urlImagem"],
                                                      dados["quantidade"]);
                                                }),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ));
                    }),
                  );
                }
                break;
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_grocery_store),
        backgroundColor: Color(0xffFF0000),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/listaCompras",
          );
        },
      ),
    );
  }
}
