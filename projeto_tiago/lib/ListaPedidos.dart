import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';

class ListaPedidos extends StatefulWidget {
  @override
  _ListaPedidosState createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  StreamController _controller = StreamController.broadcast();
  String _nomeUsuario;
  String _idUsuario;

  _recuperaUsuario() async {
    String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
    Map<String, dynamic> dadosUsuario;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios").doc(uid).get();
    dadosUsuario = snapshot.data();
    _idUsuario = dadosUsuario["idUsuario"];
    _nomeUsuario = dadosUsuario["nome"];
  }

  _recuperaPedidos() {
    var stream = FirebaseFirestore.instance.collection("listaCompra");
    stream.where("status", isEqualTo: "Pendente").snapshots().listen((event) {
      if (mounted) {
        _controller.add(event);
      }
    });
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _confirmarPedido(String idDocumento) {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar pedido"),
            content: Container(
              width: 150,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Confirmar Rebimento do pedido?",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("listaCompra").doc(idDocumento).update({
                    "idEntregador": _idUsuario,
                    "nomeEntregador": _nomeUsuario,
                    "dataRecebimento": DateTime.now().toString(),
                    "status": "Recebido"
                  });
                  Navigator.pop(context);
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaPedidos();
    _recuperaUsuario();
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
        title: Text("Entregas"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: StreamBuilder(
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
                            "Sem pedidos no momento",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<DocumentSnapshot> requisicoes =
                            querySnapshot.docs.toList();
                        DocumentSnapshot dados = requisicoes[indice];
                        return Card(
                          elevation: 8,
                          color: dados["status"] == "Recebido"
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                          child: ListTile(
                              onLongPress: () {
                                _confirmarPedido(dados.reference.id);
                              },
                              onTap: () {
                                Navigator.pushNamed(context, "/detalhesentrega",
                                    arguments: dados["listaProdutos"]);
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
                                      "Cidade: " + dados["cidade"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Ponto de refrência: " +
                                          dados["prontoReferencia"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Valor total: R\$ " +
                                          dados["totalCompra"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Troco: R\$ " + dados["troco"],
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
                                      "Data da Compra: " +
                                          _formatarData(dados["dataCompra"]),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
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
