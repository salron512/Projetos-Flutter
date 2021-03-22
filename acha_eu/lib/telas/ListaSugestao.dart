import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaSugestao extends StatefulWidget {
  @override
  _ListaSugestaoState createState() => _ListaSugestaoState();
}

class _ListaSugestaoState extends State<ListaSugestao> {
  Future _recuperaSugestao() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var snapshots = await db.collection("sugestao").get();
    var ref = await db.collection("sugestao").doc().id;
    List<Usuario> listaRecuperada = List();
    for (var item in snapshots.docs) {
      Map<String, dynamic> dados = item.data();
      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.telefone = dados["telefone"];
      usuario.whatsapp = dados["whatsapp"];
      usuario.categoriaUsuario = dados["categoria"];
      usuario.ref = item.id;
      listaRecuperada.add(usuario);
    }
    return listaRecuperada;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de sugestões"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffDCDCDC)),
        // ignore: missing_return
        child: FutureBuilder(
            future: _recuperaSugestao(),
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
                      child: Text("Sem Sugestões no momento :(",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: item.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        Usuario dados = item[indice];
                        return Dismissible(
                          onDismissed: (direcao)async{
                            FirebaseFirestore db = FirebaseFirestore.instance;
                            await db.collection("sugestao").doc(dados.ref).delete();
                          },
                          key: Key(DateTime.now()
                              .millisecondsSinceEpoch
                              .toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                            child:  Card(
                              color: Color(0xff37474f),
                              child: ListTile(
                                title: Text(
                                  "Nome: " + dados.nome,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "Categoria: " + dados.categoriaUsuario,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "/detalhesugestao",
                                      arguments: dados);
                                },
                              ),
                            ),
                        );
                      },
                    );
                  }
                  break;
              }
            }),
      ),
    );
  }
}
