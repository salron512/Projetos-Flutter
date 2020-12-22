import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Firestore db = Firestore.instance;
  TextEditingController _controllerTarefa = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final String email = "teste@hotmail.com";
  final String senha = "teste123456";
  String _data;


  _logarUsuario() async* {
    auth.signInWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) {})
        .catchError((erro) {
      print("erro");
    });
  }

  _salvarTarefa() async {
      await db.collection("item").add({
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
          title: Text("Lista Compartilhada"),
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
                    title: Text("Adicionar item"),
                    content: TextField(
                      controller: _controllerTarefa,
                      decoration:
                          InputDecoration(labelText: "Digite o item"),
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
              stream: db.collection("item")
              .orderBy("data", descending: false)
                  .snapshots(),
              // ignore: missing_return
            builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                return Center(
                    child: Column(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(8),
                          child:  Text("Sem conexão!") ,
                        )
                      ],
                    )
                );
              case ConnectionState.waiting:
                return Center(
                    child: Column(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(padding: EdgeInsets.all(8),
                          child:  Text("Carregando seus itens") ,
                        )
                      ],
                    )
                );
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
                        List<DocumentSnapshot> itens = querySnapshot.documents.toList();
                        DocumentSnapshot item = itens[indice];
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
