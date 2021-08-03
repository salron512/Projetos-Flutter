import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaIndicacoes extends StatefulWidget {
  const ListaIndicacoes({Key key}) : super(key: key);

  @override
  _ListaIndicacoesState createState() => _ListaIndicacoesState();
}

class _ListaIndicacoesState extends State<ListaIndicacoes> {
  StreamController _streamController = StreamController.broadcast();

  _recuperaLista() {
    var reference =
        FirebaseFirestore.instance.collection("indicacoes").snapshots();

    reference.listen((event) {
      _streamController.add(event);
      print("quantidade de docs " + event.docs.length.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaLista();
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
          title: Text("Lista indicações"),
        ),
        body: Container(
          child: StreamBuilder(
            stream: _streamController.stream,
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  QuerySnapshot querySnapshot = snapshot.data;
                  if (querySnapshot.docs.length == 0) {
                    return Center(
                      child: Text('Sem indicações no momento!'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, indice) {
                        List<QueryDocumentSnapshot> list =
                            querySnapshot.docs.toList();
                        QueryDocumentSnapshot indicacao = list[indice];
                        return ListTile(
                          title: Text("Empresa: " + indicacao["nomeFantasia"]),
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
