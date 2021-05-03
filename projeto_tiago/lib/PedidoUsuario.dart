import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';

class PedidoUsuario extends StatefulWidget {
  @override
  _PedidoUsuarioState createState() => _PedidoUsuarioState();
}

class _PedidoUsuarioState extends State<PedidoUsuario> {
  StreamController _controller = StreamController.broadcast();

  _recuperaPedidos() {
    String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();

    Query stream = FirebaseFirestore.instance.collection("listaCompra");

    stream
        .orderBy("dataCompra", descending: true)
        .where("idUsuario", isEqualTo: uid)
        .snapshots()
        .listen((event) {
      _controller.add(event);
    });
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _apagaSolcilitacao(String id, String status) {
    if (status == "Pendente") {
      showDialog(
          context: context,
          // ignore: missing_return
          builder: (context) {
            return AlertDialog(
              title: Text("Excluir pedido"),
              content: Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Image.asset("images/excluir.png"),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseFirestore db = FirebaseFirestore.instance;
                    db.collection("listaCompra").doc(id).delete();
                  },
                  child: Text("Confirmar"),
                ),
              ],
            );
          });
    }
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
          title: Text("Pedidos"),
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
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot = snapshot.data;
                    if (querySnapshot.docs.length == 0) {
                      return Center(
                        child: Text(
                          "Sem pedidos no momento",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
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
                          return dados["status"] == "Recebido"
                              ? Card(
                                  elevation: 8,
                                  color: dados["status"] == "Recebido"
                                      ? Colors.green
                                      : Theme.of(context).primaryColor,
                                  child: ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/detalhesentrega",
                                            arguments: dados["listaProdutos"]);
                                      },
                                      title: Text(
                                        "Cliente: " + dados["nome"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "Telefone: " + dados["telefone"],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Whatsapp: " + dados["whatsapp"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Endereço: " + dados["endereco"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Bairro: " + dados["bairro"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Cidade: " + dados["cidade"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Ponto de refêrencia: " +
                                                  dados["prontoReferencia"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Valor total: R\$ " +
                                                  dados["totalCompra"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Troco: R\$ " + dados["troco"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Status: " + dados["status"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Data da Compra: " +
                                                  _formatarData(
                                                      dados["dataCompra"]),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Entregador: " +
                                                  dados["nomeEntregador"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: Text(
                                              "Data de saída: " +
                                                  _formatarData(
                                                      dados["dataRecebimento"]),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          dados["entrega"] == "iniciada"
                                              ? TextButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                        context, "/mapa",
                                                        arguments:
                                                            dados.reference.id);
                                                  },
                                                  child: Text(
                                                    "Acompanhar entrega",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.all(2),
                                                  child: Text(" "),
                                                ),
                                        ],
                                      )),
                                )
                              : Card(
                                  elevation: 8,
                                  color: Theme.of(context).primaryColor,
                                  child: ListTile(
                                      onLongPress: () {
                                        _apagaSolcilitacao(dados.reference.id,
                                            dados["status"]);
                                      },
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/detalhesentrega",
                                            arguments: dados["listaProdutos"]);
                                      },
                                      title: Text(
                                        "Cliente: " + dados["nome"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "Telefone: " + dados["telefone"],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Whatsapp: " + dados["whatsapp"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Endereço: " + dados["endereco"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Bairro: " + dados["bairro"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Cidade: " + dados["cidade"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Ponto de referência: " +
                                                  dados["prontoReferencia"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Valor total: R\$ " +
                                                  dados["totalCompra"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Troco: R\$ " + dados["troco"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Status: " + dados["status"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Data da Compra: " +
                                                  _formatarData(
                                                      dados["dataCompra"]),
                                              style: TextStyle(
                                                  color: Colors.white),
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
        ));
  }
}
