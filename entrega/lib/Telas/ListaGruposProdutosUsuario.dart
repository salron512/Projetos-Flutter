import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/GrupoProdutos.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';

class ListaGruposProdutosUsuario extends StatefulWidget {
  var idEmpresa;
  ListaGruposProdutosUsuario(this.idEmpresa);
  @override
  _ListaGruposProdutosUsuarioState createState() =>
      _ListaGruposProdutosUsuarioState();
}

class _ListaGruposProdutosUsuarioState
    extends State<ListaGruposProdutosUsuario> {
  String _tipoUsuario = '';
  String _idEmpresa;
  _recuperaGrupos() async {
    _idEmpresa = widget.idEmpresa;
    String idEmpresa = widget.idEmpresa;
    List listaGrupo = [];

    CollectionReference reference =
        FirebaseFirestore.instance.collection("grupoProduto");

    QuerySnapshot querySnapshot = await reference
        //.orderBy('nome', descending: false)
        .where("idEmpresa", isEqualTo: idEmpresa)
        .get();
    for (var item in querySnapshot.docs) {
      Map<String, dynamic> dados = item.data();
      GrupoProduto grupoProduto = GrupoProduto();
      grupoProduto.nome = dados['nome'];
      grupoProduto.idEmpresa = idEmpresa;
      listaGrupo.add(grupoProduto);
    }
    return listaGrupo;
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
    // TODO: implement initState
    super.initState();
    _recuperaUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _recuperaGrupos(),
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
                List listaSnap = snapshot.data;
                if (listaSnap.isEmpty) {
                  return Center(child: Text("Sem opções para essa categoria"));
                } else {
                  return ListView.builder(
                      itemCount: listaSnap.length,
                      itemBuilder: (context, indice) {
                        GrupoProduto grupo = listaSnap[indice];
                        return Card(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: Text(
                              grupo.nome,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, "/listaprodutosusuario",
                                  arguments: grupo);
                            },
                          ),
                        );
                      });
                }
                break;
            }
          },
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
