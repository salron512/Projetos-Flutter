import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ListaPedidosEmpresa extends StatefulWidget {
  @override
  _ListaPedidosEmpresaState createState() => _ListaPedidosEmpresaState();
}

class _ListaPedidosEmpresaState extends State<ListaPedidosEmpresa> {
  StreamController _streamController = StreamController.broadcast();

  // ignore: missing_return
  Stream _recuperaPedidos() {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();

    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .orderBy("horaPedido")
        .where("idEmpresa", isEqualTo: uid)
        .where("andamento", isEqualTo: true)
        .snapshots()
        .listen((event) {
      if (mounted) {
        _streamController.add(event);
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

  _confirmarRecebimento(DocumentSnapshot pedido) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar entrega"),
            content: Container(
              height: 150,
              child: Column(
                children: [Text("Deseja confirmar a entrega?")],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("pedidos")
                        .doc(pedido.reference.id)
                        .update({"status": "Recebido"});
                    Navigator.pop(context);
                  },
                  child: Text("Confirmar"))
            ],
          );
        });
  }

  _selecionaOpcao(QueryDocumentSnapshot entrega) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selecione uma ação"),
            content: Container(
              width: 80,
              height: 80,
              child: Image.asset("images/food-delivery.png"),
            ),
            actions: [
              TextButton(
                child: Text("Cancelar entrega"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Confirmar entrega"),
                onPressed: () {
                   Navigator.pop(context);
                  _confirmarRecebimento(entrega);
                },
              ),
              TextButton(
                child: Text("Finalizar entrega"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Telefone cliente"),
                onPressed: () {},
              ),
              TextButton(
                child: Text("Whatsapp cliente"),
                onPressed: () {},
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
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Entregas pendentes"),
        ),
        body: Container(
          child: StreamBuilder(
            stream: _streamController.stream,
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
                      child: Text("Sem entregas no momento"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<QueryDocumentSnapshot> lista =
                            querySnapshot.docs.toList();
                        QueryDocumentSnapshot entrega = lista[indice];
                        return Card(
                          color: entrega["status"] == "Recebido"
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                          elevation: 8,
                          child: ListTile(
                            title: Text(
                              "Cliente " + entrega["cliente"],
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estabelecimento " + entrega["nomeEmpresa"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Forma de pagamento " +
                                      entrega["formaPagamento"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Troco R\$ " + entrega["troco"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Valor total R\$ " + entrega["totalPedido"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Endereço " + entrega["enderecoUsuario"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Bairro " + entrega["bairroUsuario"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Hora do pedido " +
                                      _formatarData(entrega["horaPedido"]),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Status " + entrega["status"],
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            onLongPress: () {
                              _selecionaOpcao(entrega);
                            },
                            onTap: () {
                              Navigator.pushNamed(context, "/detalhesentrega",
                                  arguments: entrega["listaPedido"]);
                            },
                          ),
                        );
                      },
                    );
                  }
                  break;
              }
            },
          ),
        ));
  }
}
