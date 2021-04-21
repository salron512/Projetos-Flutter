import 'dart:async';
import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ListaTrabalhos extends StatefulWidget {
  @override
  _ListaTrabalhosState createState() => _ListaTrabalhosState();
}

class _ListaTrabalhosState extends State<ListaTrabalhos> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Usuario _usuario = Usuario();

  // ignore: missing_return
  Stream _recuperaSolicitacao() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final stream = db
        .collection("solicitacao")
        .where("idProfissional", isEqualTo: _usuario.idUsuario)
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
    if (!_controller.hasListener) {
      final stream = db
          .collection("solicitacao")
          .where("status", isEqualTo: "Em atendimento")
          .where("idProfissional", isEqualTo: _usuario.idUsuario)
          .snapshots();
      stream.listen((event) {
        _controller.add(event);
      });
    } else {
      final stream = db
          .collection("solicitacao")
          .where("status", isEqualTo: "Em atendimento")
          .where("idProfissional", isEqualTo: _usuario.idUsuario)
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
        title: Text("Pedidos em Atendimento"),
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
                   // decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sem trabalhos no momento :(",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                  );
                } else {
                  return Container(
                  //  decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<DocumentSnapshot> requisicoes =
                            querySnapshot.docs.toList();
                        DocumentSnapshot dados = requisicoes[indice];
                        return Card(
                          color: Color(0xff37474f),
                          child: ListTile(
                              onTap: (){
                                Navigator.pushNamed(context, "/detalhesPedidos" , arguments: dados );
                              },
                              title: Text("Cliente: "+
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
