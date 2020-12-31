import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_mercado/Adicionar.dart';
import 'package:lista_mercado/Login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _controllerTarefa = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String _data;
  String _idUsuarioLogado;
  String _usuarioLogado ="";
  Color _cor = Colors.purple;
  int index = 0;
  _salvarTarefa() async {
    await db.collection("item").add({
      "data": _data = DateTime.now().millisecondsSinceEpoch.toString(),
      "titulo": _controllerTarefa.text,
      "estado": false,
      "idUsuario": _idUsuarioLogado
    });

    _controllerTarefa.clear();
  }

    _recuperaNomeUsuario() async{
    DocumentSnapshot snapshot = await db.collection("usuarios").doc(_idUsuarioLogado).get();
     var dados = snapshot.data();
     print("Usuario " + dados["nome"]);
     setState(() {
       _usuarioLogado = dados["nome"];
     });
  }




   _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuariologado = await auth.currentUser;
    _idUsuarioLogado = usuariologado.uid;
    print("ID usuario " + _idUsuarioLogado);

    if (usuariologado == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    _recuperaNomeUsuario();
  }


  @override
  void initState() {
    super.initState();
    _verificaUsuarioLogado();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("Lista Compartilhada"),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Column(
                    children:<Widget> [
                      Text(_usuarioLogado),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Lista'),
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                 Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Adicionar membros'),
                onTap: () {
                  Navigator.push
                    (context, MaterialPageRoute(builder: (context) => Adicionar()));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Deslogar"),
                onTap: () {
                  auth.signOut();
                  Navigator.push
                    (context, MaterialPageRoute(builder: (context) => Login()));
                  setState(() {
                  });
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Adicionar item"),
                    content: TextField(
                      controller: _controllerTarefa,
                      decoration: InputDecoration(labelText: "Digite o item"),
                      onChanged: (text) {},
                    ),
                    actions: <Widget>[
                      FlatButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            _controllerTarefa.clear();
                            Navigator.pop(context);
                          }),
                      FlatButton(
                        child: Text("Salvar"),
                        onPressed: () {
                          _salvarTarefa();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          },
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: db
                    .collection("item")
                    .orderBy("data", descending: false)
                    .snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Sem conexão!"),
                          )
                        ],
                      ));
                    case ConnectionState.waiting:
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Carregando seus itens"),
                          )
                        ],
                      ));
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      QuerySnapshot querySnapshot = snapshot.data;
                      if (snapshot.hasError) {
                        return Expanded(
                          child: Text("Erro ao carregar os dados!"),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: querySnapshot.documents.length,
                            // ignore: missing_return
                            itemBuilder: (context, indice) {
                              List<DocumentSnapshot> itens =
                                  //querySnapshot.documents.toList();
                                  querySnapshot.docs.toList();
                              DocumentSnapshot item = itens[indice];
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                    padding: EdgeInsets.all(8),
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )),
                                key: Key(DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString()),
                                onDismissed: (direcao) {
                                  db
                                      .collection("item")
                                      .document(item.documentID)
                                      .delete();
                                },
                                child: CheckboxListTile(
                                  activeColor:
                                      item["idUsuario"] == _idUsuarioLogado
                                          ? Colors.purple
                                          : Colors.blue,
                                  title: Text(item["titulo"]),
                                  value: item["estado"],
                                  onChanged: (valorAlterado) {
                                    Map<String, dynamic> dadosAtualizar = {
                                      "estado": valorAlterado,
                                      "idUsuario": _idUsuarioLogado,
                                    };
                                    //db.collection("item").document(item.documentID).updateData(dadosAtualizar);
                                    db.collection("item").doc(item.id).update(dadosAtualizar);
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }
                      break;
                  }
                },
              ),
            ],
          ),
        ));
  }
}
