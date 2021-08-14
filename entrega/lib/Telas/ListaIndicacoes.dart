import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      if (mounted) {
        _streamController.add(event);
      }
      // print("quantidade de docs " + event.docs.length.toString());
    });
  }

  _deletaIndicacao(QueryDocumentSnapshot queryDocumentSnapshot) async {
    String idDoc = queryDocumentSnapshot.reference.id;
    await FirebaseFirestore.instance
        .collection("indicacoes")
        .doc(idDoc)
        .delete();
  }

  _abrirTelefone(String telefone) async {
    var telefoneUrl = "tel:$telefone";

    if (await canLaunch(telefoneUrl)) {
      await launch(telefoneUrl);
    } else {
      throw 'Could not launch $telefoneUrl';
    }
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
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Telefone: " + indicacao["telefone"])],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _deletaIndicacao(indicacao);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onLongPress: () {
                        _abrirTelefone(indicacao["telefone"]);
                      },
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Sem indicações no momento!'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
