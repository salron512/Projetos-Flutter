import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaEntregas extends StatefulWidget {
  @override
  _ListaEntregasState createState() => _ListaEntregasState();
}

class _ListaEntregasState extends State<ListaEntregas> {
  StreamController _controller = StreamController.broadcast();
  _recuperaPedidos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String id = auth.currentUser.uid;
    var stream = db
        .collection("pedido")
        .where("idEntregador", isEqualTo: id)
        .where("status", isEqualTo: "recebido")
        .snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
    if (!_controller.hasListener) {
      var stream = db
          .collection("pedido")
          .where("idEntregador", isEqualTo: id)
          .where("status", isEqualTo: "recebido")
          .snapshots();
      stream.listen((event) {
        _controller.add(event);
      });
    } else {
      var stream = db
          .collection("pedido")
          .where("idEntregador", isEqualTo: id)
          .where("status", isEqualTo: "recebido")
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

  _mostraMsg(DocumentSnapshot dados) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text(""),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Text(
                    "Defina uma ação",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _finalizaEntrega(dados);
                },
                child: Text("Finalizar entrega"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _cancelarEntrega(dados);
                },
                child: Text("Cancelar entrega"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _abrirTelefone(dados["telefone"]);
                },
                child: Text("Ligar para o cliente"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _abrirWhatsApp(dados["whatsapp"]);
                },
                child: Text("Whatsapp do cliente"),
              ),
            ],
          );
        });
  }

  _finalizaEntrega(DocumentSnapshot dados) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Finalizar"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Text(
                    "Deseja realmente finalizar a entrega?",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Não"),
              ),
              TextButton(
                child: Text("Sim"),
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("entregasRealizadas").doc().set({
                    "idUsuario": dados["idUsuario"],
                    "nomeUsuario": dados["nome"],
                    "telefone": dados["telefone"],
                    "whatsapp": dados["whatsapp"],
                    "endereco": dados["endereco"],
                    "bairro": dados["bairro"],
                    "status": "entregue",
                    "cidade": dados["cidade"],
                    "pontoReferencia": dados["pontoReferencia"],
                    "listaCompras": dados["listaCompras"],
                    "idEntregador": dados["idEntregador"],
                    "nomeEntregador": dados["nomeEntregador"],
                    "dataEntrega": DateTime.now().toString(),
                    "data": dados["data"],
                  });
                  db.collection("pedido").doc(dados.reference.id).delete();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/carrinho", (route) => false);
                },
              ),
            ],
          );
        });
  }

  _abrirWhatsApp(String telefone) async {
    var whatsappUrl = "whatsapp://send?phone=+55$telefone=Olá,tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  _abrirTelefone(String telefone) async {
    var telefoneUrl = "tel:$telefone";

    if (await canLaunch(telefoneUrl)) {
      await launch(telefoneUrl);
    } else {
      throw 'Could not launch $telefoneUrl';
    }
  }

  _cancelarEntrega(DocumentSnapshot dados) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Finalizar"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Text(
                    "Deseja realmente excluir a entrega?",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Não"),
              ),
              TextButton(
                child: Text("Sim"),
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("pedido").doc(dados.reference.id).delete();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/carrinho", (route) => false);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaPedidos();
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
        title: Text("Entregas em andamento"),
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
                          "Sem pedidos no momento",
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
                        return Card(
                          color: dados["status"] == "recebido"
                              ? Colors.green
                              : Color(0xffFF0000),
                          child: ListTile(
                              onLongPress: () {
                                _mostraMsg(dados);
                              },
                              onTap: () {
                                Navigator.pushNamed(context, "/detalhesentrega",
                                    arguments: dados["listaCompras"]);
                              },
                              title: Text(
                                "Cliente: " + dados["nome"],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Telefone: " + dados["telefone"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Whatsapp: " + dados["whatsapp"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Endereço: " + dados["endereco"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Bairro: " + dados["bairro"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Ponto de referêcia: " +
                                          dados["pontoReferencia"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Cidade: " + dados["cidade"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Data do pedido: " +
                                          _formatarData(dados["data"]),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Status: " + dados["status"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Entregador: " + dados["nomeEntregador"],
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
