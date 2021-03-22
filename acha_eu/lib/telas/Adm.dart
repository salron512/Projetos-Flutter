import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Adm extends StatefulWidget {
  @override
  _AdmState createState() => _AdmState();
}

class _AdmState extends State<Adm> {
  List<String> itensMenu = ["Sugestões"];



  Future _recuperaDadosUsuario() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot snapshots = await db
        .collection("usuarios")
        .orderBy("nome", descending: false)
        .get();
    List<Usuario> listaDados = List();
    for (var item in snapshots.docs) {
      Map<String, dynamic> dados = item.data();
      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.idUsuario = dados["idUsuario"];
      usuario.telefone = dados["telefone"];
      usuario.adm = dados["adm"];
      usuario.categoriaUsuario = dados["categoria"];
      usuario.mostraPagamento = dados["mostraPagamento"];
      usuario.idUsuario = dados["idUsuario"];
      usuario.email = dados["email"];
      listaDados.add(usuario);
    }
    return listaDados;
  }
  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Sugestões":
        Navigator.pushNamed(context, "/listaSugestao");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de usuarios"),
        actions: [
          PopupMenuButton<String>(
            color: Color(0xff37474f),
            onSelected: _escolhaMenuItem,
            // ignore: missing_return
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item,
                      style: TextStyle(
                          color: Colors.white
                      )
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _recuperaDadosUsuario(),
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                List<Usuario> item = snapshot.data;
                if (item.isEmpty) {
                  return Center(
                    child: Text("Sem usuarios cadastrados :("),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: item.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        Usuario dados = item[indice];
                        return Card(
                          color: Color(0xff37474f),
                          child: ListTile(
                            title: Text(
                              dados.nome,
                              style: TextStyle(color: Color(0xffDCDCDC)),
                            ),
                            subtitle: dados.mostraPagamento == true
                                ? Text(
                                    "Anunciante",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "Não anunciante",
                                    style: TextStyle(color: Colors.white),
                                  ),
                            onTap: () {
                              Navigator.pushNamed(context, "/detalhesAdm",
                                  arguments: dados);
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                break;
            }
          }),
    );
  }
}
