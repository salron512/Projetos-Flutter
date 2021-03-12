import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Mapas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _adicionarLocal() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Mapas()));
  }

  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore _db = Firestore.instance;

  _abrirMapa(String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => Mapas(
                  IdViagem: id,
                )));
  }

  _excluirViagem(String id) {
    _db.collection("viagens").document(id).delete();
  }

  _adicionarListenerViagens() async {
    final stream = _db.collection("viagens").snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerViagens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Minhas Viagens"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(0xff0066cc),
          onPressed: () {
            _adicionarLocal();
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: Text("Carregando!"));
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot querySnapshot = snapshot.data;
                List<DocumentSnapshot> viagens =
                    querySnapshot.documents.toList();
                return Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: viagens.length,
                            // ignore: missing_return
                            itemBuilder: (context, index) {
                              DocumentSnapshot item = viagens[index];
                              String tiutlo = item["titulo"];
                              String idViagem = item.documentID;
                              return GestureDetector(
                                onTap: () {
                                  _abrirMapa(idViagem);
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(tiutlo),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _excluirViagem(idViagem);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ],
                );
                break;
            }
          },
        ));
  }
}
