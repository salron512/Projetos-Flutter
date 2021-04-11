import 'dart:async';
import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ListaPedidos extends StatefulWidget {
  String categoria;
  ListaPedidos(this.categoria);
  @override
  _ListaPedidosState createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Usuario _usuario = Usuario();

  // ignore: missing_return
  Stream _recuperaSolicitacao() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String categoria = widget.categoria;

    final stream = db
        .collection("solicitacao")
        .where("status", isEqualTo: "Não atendido")
        .where("cidade", isEqualTo: _usuario.cidade)
        .where("categoria", isEqualTo: categoria)
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
    if (!_controller.hasListener) {
      final stream = db
          .collection("solicitacao")
          .where("status", isEqualTo: "Não atendido")
          .where("cidade", isEqualTo: _usuario.cidade)
          .where("categoria", isEqualTo: categoria)
          .snapshots();
      stream.listen((event) {
        _controller.add(event);
      });
    } else {
      final stream = db
          .collection("solicitacao")
          .where("status", isEqualTo: "Não atendido")
          .where("cidade", isEqualTo: _usuario.cidade)
          .where("categoria", isEqualTo: categoria)
          .orderBy("data", descending: true)
          .snapshots();
      stream.listen((event) {
        _controller.add(event);
      });
    }
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
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
                  return Container(
                    decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sem pedidos no momento :(",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  );
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
                                .update({
                              "idProfissional": _usuario.idUsuario,
                              "nomeProfissional": _usuario.nome,
                              "telefoneProfissional": _usuario.telefone,
                              "dataResposta": DateTime.now().toString(),
                              "status": "Em atendimento",
                            });
                            /*
                            await db
                                .collection("solicitacao_atendida")
                                .doc(dados.reference.id)
                                .update({
                              "idSolicitante": _usuario.idUsuario,
                              "nome": _usuario.nome,
                              "telefone": _usuario.telefone,
                              "whatsapp": _usuario.whatsapp,
                              "cidade": _usuario.cidade,
                              "categoria": dados["categoria"],
                              "descricao": dados["descricao"],
                              "data": DateTime.now().toString(),
                              "status": "Atendido",
                            });
                             */
                          },
                          key: Key(
                              DateTime.now().millisecondsSinceEpoch.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.green,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.work,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Data: " + _formatarData(dados["data"]),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )),
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
