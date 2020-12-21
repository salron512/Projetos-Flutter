import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_mercado/Itens.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Firestore db = Firestore.instance;
  Map<String, dynamic> _ultimoTarefaRemovida = Map();
  TextEditingController _controllerTarefa = TextEditingController();
  List <Itens> _listaTarefas = List();

  FirebaseAuth auth = FirebaseAuth.instance;
  final String email = "andre.lptv@hotmail.com";
  final String senha = "andre512";
  String _data;

  Itens itens = Itens();

   /* _recuperalista() async {

      Itens itens = Itens();
    QuerySnapshot querySnapshot = await db.collection("item").getDocuments();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      Itens itens = Itens();
      itens.item = dados["item"];
      itens.estado = dados["estado"];
      itens.data = dados["data"];

     return  _listaTarefas.add(itens);
    }
    print(_listaTarefas);
  }
    */

  _logarUsuario() async* {
    auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) {})
        .catchError((erro) {
      print("erro");
    });
  }

  _salvarTarefa() async {
    DocumentReference ref = await db.collection("item").add({
      "data": _data = DateTime.now().millisecondsSinceEpoch.toString(),
      "titulo": _controllerTarefa.text,
      "estado": false
    });

    _controllerTarefa.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _logarUsuario();
    //_recuperalista();
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("Lista de compras"),
        ),
         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Adicionar Tarefa"),
                    content: TextField(
                      controller: _controllerTarefa,
                      decoration:
                          InputDecoration(labelText: "Digite sua tarefa"),
                      onChanged: (text) {},
                    ),
                    actions: <Widget>[
                      FlatButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            _controllerTarefa.text = "";
                            Navigator.pop(context);
                          }),
                      FlatButton(
                        child: Text("Salvar"),
                        onPressed: () {
                          _salvarTarefa();
                          //_recuperalista();
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
            children: [

            StreamBuilder(
              stream: db.collection("item")
              .orderBy("data", descending: false)
                  .snapshots(),
          // ignore: missing_return
            builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Column(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(padding: EdgeInsets.all(8),
                          child:  Text("Carregando sua mensagens") ,
                        )
                      ],
                    ));
                break;
              case ConnectionState.active:
              case ConnectionState.done:

                QuerySnapshot querySnapshot = snapshot.data;

                if(snapshot.hasError){
                  return Expanded(
                    child: Text("Erro ao carregar os dados!"),
                  );
                }else{
                  return Expanded(
                    child: ListView.builder(
                      itemCount: querySnapshot.documents.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice){
                        List<DocumentSnapshot> mensagens = querySnapshot.documents.toList();
                        DocumentSnapshot item = mensagens[indice];
                        return  Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:<Widget> [
                                  Icon(Icons.delete, color: Colors.white,),
                                ],
                              )
                          ),
                          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                          onDismissed: (direcao){
                            db.collection("item")
                                .document(item.documentID)
                                .delete();
                          },
                          child: CheckboxListTile(
                            activeColor: Colors.purple,
                            title: Text( item["titulo"]),
                            value: item["estado"],
                            onChanged: (valorAlterado){

                            Map<String, dynamic> dadosAtualizar = {
                              "estado": valorAlterado
                            };
                              db.collection("item")
                                  .document(item.documentID)
                                  .updateData(dadosAtualizar);
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
        )
        );
  }
}
