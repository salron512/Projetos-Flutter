import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';

class ListaEntregasRealizadas extends StatefulWidget {
  @override
  _ListaEntregasRealizadasState createState() =>
      _ListaEntregasRealizadasState();
}

class _ListaEntregasRealizadasState extends State<ListaEntregasRealizadas> {
  StreamController _streamController = StreamController.broadcast();

  _recuperaEntregas() async {
    String mes = DateTime.now().month.toString();
    String ano = DateTime.now().year.toString();
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .where("idEntregador", isEqualTo: uid)
        .where("status", isEqualTo: "Finalizada")
        .where("mes", isEqualTo: mes)
        .where("ano", isEqualTo: ano)
        .snapshots()
        .listen((event) {
      if (mounted) {
        _streamController.add(event);
      }
    });
  }

  _seletorData() {
    List<String> listaMes = [
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "12",
    ];
    List<String> listaAno = [
      "2021",
    ];
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selecione a data"),
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
        title: Text("Entregas realizadas"),
        actions: [
          IconButton(
              onPressed: () {
                _seletorData();
              },
              icon: Icon(Icons.calendar_today_outlined))
        ],
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
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot query = snapshot.data;
                if (query.docs.length == 0) {
                  return Center(
                    child: Text("Sem entregas Realizadas"),
                  );
                } else {
                  return ListView.separated(
                      separatorBuilder: (context, indice) => Divider(
                            height: 4,
                            color: Colors.grey,
                          ),
                      itemCount: query.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<QueryDocumentSnapshot> lista = query.docs.toList();
                        QueryDocumentSnapshot entrega = lista[indice];
                        return ListTile(
                          title: Text(entrega["nomeEmpresa"]),
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
