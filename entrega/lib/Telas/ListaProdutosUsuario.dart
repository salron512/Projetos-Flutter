import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Produtos.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// ignore: must_be_immutable
class ListaProdutosUsuario extends StatefulWidget {
  String id;
  ListaProdutosUsuario(this.id);
  @override
  _ListaProdutosUsuarioState createState() => _ListaProdutosUsuarioState();
}

class _ListaProdutosUsuarioState extends State<ListaProdutosUsuario> {
  String _idEmpresa;
  String _tipoUsuario = '';
  var _mascaraQtd = MaskTextInputFormatter(
      mask: '#########', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _controllerObj = TextEditingController();

  Future _recuperaProdutos() async {
    List<Produtos> listaProdutos = [];
    String idEmpresa = widget.id;

    CollectionReference reference =
        FirebaseFirestore.instance.collection("produtos");

    QuerySnapshot snapshot = await reference
        .orderBy("nome", descending: false)
        .where("idEmpresa", isEqualTo: idEmpresa)
        .get();

    for (var item in snapshot.docs) {
      Map<String, dynamic> dados = item.data();
      Produtos produtos = Produtos();
      if (dados["estoque"] < 1 && dados["estoqueAtivo"]) continue;
      produtos.nome = dados["nome"];
      produtos.estoque = dados["estoque"];
      produtos.estoqueAtivo = dados["estoqueAtivo"];
      produtos.preco = dados["preco"];
      produtos.descricao = dados["descricao"];
      produtos.urlImagem = dados["urlImagem"];
      produtos.idEmpresa = dados["idEmpresa"];
      produtos.id = item.reference.id;
      _idEmpresa = dados["idEmpresa"];
      listaProdutos.add(produtos);
    }
    return listaProdutos;
  }

  _addCesta(Produtos produto, int qtd) {
    String idProduto = produto.id;
    String observacao = _controllerObj.text;
    double precoUnitario = double.parse(produto.preco).toDouble();
    double precoTotal = precoUnitario * qtd;
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    FirebaseFirestore.instance
        .collection("cesta")
        .doc(uid)
        .collection(uid)
        .doc(idProduto)
        .set({
      "estoqueAtivo": produto.estoqueAtivo,
      'idProduto': idProduto,
      "idUsuario": uid,
      "precoUnitario": precoUnitario,
      "precoTotal": precoTotal,
      "qtd": qtd,
      "produto": produto.nome,
      "observacao": observacao,
      "idEmpresa": produto.idEmpresa
    });
  }

  _alertErro(String erro) {
    print("alert");
    showDialog(
        context: context,
        builder: (BuildContext context) {
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

  _alerQtd(Produtos produto) {
    TextEditingController controllerQtd = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adicione a quantidade"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: Image.asset("images/produto.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(produto.nome),
                  ),
                  Text("valor R\$ " + produto.preco),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: TextField(
                      autofocus: true,
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
                  ),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Observação",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _controllerObj,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                    _controllerObj.clear();
                  }),
              TextButton(
                child: Text("Confirmar"),
                onPressed: () {
                  int qtd = 0;
                  if (controllerQtd.text.isNotEmpty) {
                    qtd = int.parse(controllerQtd.text).toInt();
                    if (produto.estoqueAtivo && produto.estoque < qtd) {
                      print("teste01");
                      _alertErro("Preencha a quantidade");
                    } else {
                      _addCesta(produto, qtd);
                    }
                  } else {
                    print("teste");
                    _alertErro("Preencha a quantidade");
                  }
                  Navigator.pop(context);
                  _controllerObj.clear();
                },
              ),
            ],
          );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: _recuperaProdutos(),
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
                case ConnectionState.active:
                case ConnectionState.done:
                  List listaProdutos = snapshot.data;
                  if (listaProdutos.isEmpty) {
                    return Center(
                      child: Text("Sem produtos cadastrados"),
                    );
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 4,
                        color: Theme.of(context).primaryColor,
                      ),
                      itemCount: listaProdutos.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        Produtos produtos = listaProdutos[indice];
                        return Container(
                            padding: EdgeInsets.all(4),
                            child: GestureDetector(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  produtos.urlImagem != null
                                      ? Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Image.network(
                                            produtos.urlImagem,
                                            fit: BoxFit.cover,
                                            height: 120,
                                            width: 120,
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Image.asset(
                                            "images/error.png",
                                            fit: BoxFit.cover,
                                            height: 120,
                                            width: 120,
                                          )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        produtos.nome,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("R\$ " + produtos.preco),
                                      Text(produtos.descricao),
                                      produtos.estoqueAtivo == true
                                          ? Text("Quantidade disponínel " +
                                              produtos.estoque.toString())
                                          : Text("")
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (_tipoUsuario != "empresa") {
                                  _alerQtd(produtos);
                                }
                              },
                            ));

                        /*
                         ListTile(
                          contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          leading: produtos.urlImagem == null
                              ? Image.asset("images/error.png")
                              : Container(
                                  child: Image.network(
                                    produtos.urlImagem,
                                    fit: BoxFit.cover,
                                    height: 450,
                                    width: 150,
                                  ),
                                ),
                          title: Text(produtos.nome),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("R\$ " + produtos.preco),
                              Text(produtos.descricao)
                            ],
                          ),
                          onTap: () {
                            _alerQtd(produtos);
                          },
                        );
                        */
                      },
                    );
                  }
                  break;
              }
            },
          ),
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
