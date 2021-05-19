import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Produtos.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListaProdutosUsuario extends StatefulWidget {
  String id;
  ListaProdutosUsuario(this.id);
  @override
  _ListaProdutosUsuarioState createState() => _ListaProdutosUsuarioState();
}

class _ListaProdutosUsuarioState extends State<ListaProdutosUsuario> {
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
      listaProdutos.add(produtos);
    }
    return listaProdutos;
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
                          child: ListTile(
                            contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            leading: produtos.urlImagem == null
                              ? Image.asset("images/error.png")
                              : Image.network(produtos.urlImagem),
                            title: Text(produtos.nome),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("R\$" + produtos.preco),
                                Text(produtos.descricao)
                              ],
                            ),
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
    );
  }
}
