import 'dart:async';
import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListaPedidos extends StatefulWidget {
  String categoria;
  ListaPedidos(this.categoria);
  @override
  _ListaPedidosState createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Usuario _usuario = Usuario();

  Stream _recuperaSolicitacao() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String categoria = widget.categoria;

    final stream = db
        .collection("solicitacao")
        .where("cidade", isEqualTo: _usuario.cidade)
        .where("categoria", isEqualTo: categoria)
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
    print("teste");
  }

  _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    String id = auth.currentUser.uid;

    var dadosUsuario = await db.collection("usuarios").doc(id).get();
    Map<String, dynamic> dados = dadosUsuario.data();

    _usuario.nome = dados["nome"];
    _usuario.telefone = dados["telefone"];
    _usuario.whatsapp = dados["whatsapp"];
    _usuario.cidade = dados["cidade"];
    _usuario.idUsuario = dados["idUsuario"];
    _recuperaSolicitacao();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
      ),
      body: StreamBuilder(
          stream: _controller.stream,
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
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sem pedidos no momento :(",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ));
                } else {
                  return Container(
                    decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<DocumentSnapshot> requisicoes =
                            querySnapshot.docs.toList();
                        DocumentSnapshot dados = requisicoes[indice];
                        return Dismissible(
                          onDismissed: (direcao) async {
                            FirebaseFirestore db = FirebaseFirestore.instance;
                            await db
                                .collection("solicitacao")
                                .doc(dados.reference.id)
                                .delete();
                          },
                          key: Key(
                              DateTime.now().millisecondsSinceEpoch.toString()),
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
                          child: Card(
                            color: Color(0xff37474f),
                            child: ListTile(
                              title: Text(
                                dados["nome"],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Tipo do profissional: " +
                                        dados["categoria"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Descrição: " + dados["descricao"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, "/detalhesPedidos",
                                    arguments: dados);
                              },
                            ),
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
