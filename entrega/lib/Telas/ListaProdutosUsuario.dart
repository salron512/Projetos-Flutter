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
  var _mascaraQtd = MaskTextInputFormatter(
      mask: '#########', filter: {"#": RegExp(r'[0-9]')});
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
      produtos.nome = dados["nome"];
      produtos.preco = dados["preco"];
      produtos.descricao = dados["descricao"];
      produtos.urlImagem = dados["urlImagem"];
      produtos.idEmpresa = dados["idEmpresa"];
      _idEmpresa = dados["idEmpresa"];
      listaProdutos.add(produtos);
    }
    return listaProdutos;
  }

  _addCesta(Produtos produto, int qtd) {
    double precoUnitario = double.parse(produto.preco).toDouble();
    double precoTotal = precoUnitario * qtd;
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    FirebaseFirestore.instance.collection("cesta").doc().set({
      "idUsuario": uid,
      "precoUnitario": precoUnitario,
      "precoTotal": precoTotal,
      "qtd": qtd,
      "produto": produto.nome,
      "idEmpresa": produto.idEmpresa
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
              width: 200,
              height: 230,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
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
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Confirmar"),
                onPressed: () {
                  int qtd = int.parse(controllerQtd.text).toInt();
                  _addCesta(produto, qtd);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  List listaProdutos = snapshot.data;
                  if (listaProdutos.isEmpty) {
                    return Center(
                      child: Text("Sem produtos cadastrados"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: listaProdutos.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        Produtos produtos = listaProdutos[indice];

                        return Card(
                          elevation: 8,
                          child: ListTile(
                            contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            leading: produtos.urlImagem == null
                                ? Image.asset("images/error.png")
                                : Image.network(produtos.urlImagem),
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
                          ),
                        );
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
          Navigator.pushNamed(context, "/carinho", arguments: _idEmpresa);
        },
      ),
    );
  }
}
