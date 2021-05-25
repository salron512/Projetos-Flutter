import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';

class ListEntregasPendentes extends StatefulWidget {
  @override
  _ListEntregasPendentesState createState() => _ListEntregasPendentesState();
}

class _ListEntregasPendentesState extends State<ListEntregasPendentes> {
  StreamController _streamController = StreamController.broadcast();
  _recuperaEntregas() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .orderBy("horaPedido", descending: true)
        .where("status", isEqualTo: "Aguardando")
        .snapshots()
        .listen((event) {
      if (mounted) {
        _streamController.add(event);
      }
    });
  }

  _recebeEntrega(String idDoc) {
    showDialog(
        context: context,
        builder: (contex) {
          return AlertDialog(
            title: Text("Receber entrega"),
            content: Container(
              height: 100,
              child: Column(
                children: [
                  Text("Deseja receber essa entrega?"),
                ],
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
                    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
                    FirebaseFirestore.instance
                        .collection("pedidos")
                        .doc(idDoc)
                        .update({"idEntregador": uid,
                        "status": "Recebido"
                        });
                    Navigator.pop(context);
                  },
                  child: Text("Confirmar")),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaEntregas();
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
        title: Text("Entregas"),
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
                QuerySnapshot query = snapshot.data;
                if (query.docs.isEmpty) {
                  return Center(
                    child: Text("Sem entregas no momento"),
                  );
                } else {
                  return ListView.builder(
                      itemCount: query.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<DocumentSnapshot> listQuery = query.docs.toList();
                        DocumentSnapshot entrega = listQuery[indice];
                        return Card(
                          elevation: 8,
                          child: ListTile(
                            title: Text(
                                "Local do pedido " + entrega["nomeEmpresa"]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cliente " + entrega["cliente"]),
                                Text("Forma de pagamento " +
                                    entrega["formaPagamento"]),
                                Text("Troco " + entrega["troco"]),
                                Text("Endereço " + entrega["enderecoUsuario"]),
                                Text("Bairro " + entrega["bairroUsuario"]),
                                Text("Total pedido " + entrega["totalPedido"]),
                              ],
                            ),
                            onLongPress: () {
                              _recebeEntrega(entrega.reference.id);
                            },
                            onTap: () {
                              Navigator.pushNamed(context, "/detalhesentrega",
                                  arguments: entrega["listaPedido"]);
                            },
                          ),
                        );
                      });
                }
                break;
            }
          },
        ),
      ),
    );
  }
}
