import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ListaPedidosUsuario extends StatefulWidget {
  @override
  _ListaPedidosUsuarioState createState() => _ListaPedidosUsuarioState();
}

class _ListaPedidosUsuarioState extends State<ListaPedidosUsuario> {
  StreamController _streamController = StreamController.broadcast();

  _recuperaPedidos() {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .orderBy("horaPedido", descending: true)
        .where("idUsuario", isEqualTo: uid)
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
        title: Text("Meus pedidos"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _streamController.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ));
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot query = snapshot.data;
                if (query.docs.length == 0) {
                  return Center(
                    child: Text("Sem pedidos no momento"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: query.docs.length,
                    // ignore: missing_return
                    itemBuilder: (context, indice) {
                      List<QueryDocumentSnapshot> listQuery =
                          query.docs.toList();
                      QueryDocumentSnapshot pedido = listQuery[indice];
                      return Card(
                        color: pedido["status"] == "Iniciada"
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                        child: ListTile(
                          title: Text(
                            "Cliente " + pedido["cliente"],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Estabelecimento " + pedido["nomeEmpresa"],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Valor total R\$ " + pedido["totalPedido"],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Status " + pedido["status"],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Data do pedido  " +
                                    _formatarData(pedido["horaPedido"]),
                                style: TextStyle(color: Colors.white),
                              ),
                              pedido["status"] == "À caminho"
                                  ? TextButton(
                                    
                                      onPressed: () {
                                        Navigator.pushNamed(context, "/mapa",
                                            arguments: pedido.reference.id);
                                      },
                                      child: Text("Acompanhe seu pedido",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                      ),
                                      
                                      )
                                  : Text("")
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/detalhesentrega",
                                arguments: pedido["listaPedido"]);
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
      ),
    );
  }
}
