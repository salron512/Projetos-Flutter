import 'dart:async';

import 'package:acha_eu/model/Solicitacao.dart';
import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListaSolicitacao extends StatefulWidget {
  @override
  _ListaSolicitacaoState createState() => _ListaSolicitacaoState();
}

class _ListaSolicitacaoState extends State<ListaSolicitacao> {
  TextEditingController _controllerDescricao = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  List<String> _listaCadegorias;
  Usuario _usuario = Usuario();
  String _escolhaCategoria;
  String _idUsuario;

  Stream _recuperaSolicitacao() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String id = auth.currentUser.uid;
    final stream = db
        .collection("solicitacao")
        .where("idSolicitante", isEqualTo: id)
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
    print("teste");
  }

  _recuperaCategorias() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var snapshot = await db
        .collection("categorias")
        .orderBy("categoria", descending: false)
        .get();
    List<String> listarecuperada = List();
    for (var item in snapshot.docs) {
      Map<String, dynamic> dados = item.data();
      if (dados["categoria"] == "Cliente") continue;
      listarecuperada.add(dados["categoria"]);
    }
    setState(() {
      _listaCadegorias = listarecuperada;
    });
  }

  _mostraListaCategorias() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Escolha a categoria de serviço"),
            content: ListView.separated(
              itemCount: _listaCadegorias.length,
              separatorBuilder: (context, indice) => Divider(
                height: 2,
                color: Colors.grey,
              ),
              // ignore: missing_return
              itemBuilder: (context, indice) {
                String item = _listaCadegorias[indice];
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      _escolhaCategoria = item;
                    });
                    Navigator.pop(context);
                    _criaSolicitacao();
                  },
                );
              },
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }

  _criaSolicitacao() {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Descrição de serviço"),
            content: Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 Container(
                   height: 100,
                   width: 100,
                   child:  Padding(padding: EdgeInsets.only(bottom: 2),
                     child: Image.asset("images/solicitacao.png"),
                   ),
                 ),
                  TextField(
                    controller: _controllerDescricao,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText:"Ex: Preciso de um professor de inglês" ,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  _salvaSolicitacao();
                  _controllerDescricao.clear();
                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _salvaSolicitacao() async {
    String descricao = _controllerDescricao.text;
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("solicitacao").doc().set({
      "idSolicitante": _usuario.idUsuario,
      "nome": _usuario.nome,
      "telefone": _usuario.telefone,
      "whatsapp": _usuario.whatsapp,
      "cidade": _usuario.cidade,
      "categoria": _escolhaCategoria,
      "descricao": descricao,
    });
  }

  _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    String id = auth.currentUser.uid;

    var dadosUsuario = await db.collection("usuarios").doc(id).get();
    Map<String, dynamic> dados = dadosUsuario.data();

    _usuario.nome = dados["nome"];
    _usuario.telefone = dados["telefone"];
    _usuario.whatsapp = dados["whatsapp"];
    _usuario.cidade = dados["cidade"];
    _usuario.idUsuario = dados["idUsuario"];
    _recuperaSolicitacao();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaCategorias();
    _recuperaDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suas solicitações"),
      ),
      body: StreamBuilder(
          stream: _controller.stream,
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
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Crie uma solicitado",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ));
                } else {
                  return Container(
                    decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<DocumentSnapshot> requisicoes =
                            querySnapshot.docs.toList();
                        DocumentSnapshot dados = requisicoes[indice];
                        return Dismissible(
                          onDismissed: (direcao)async{
                            FirebaseFirestore db = FirebaseFirestore.instance;
                            await db.collection("solicitacao").doc(dados.reference.id).delete();
                          },
                          key: Key(DateTime.now()
                              .millisecondsSinceEpoch
                              .toString()),
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
                          child:  Card(
                            color: Color(0xff37474f),
                            child: ListTile(
                              title: Text(
                                dados["nome"],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Tipo do profissional: " + dados["categoria"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5),
                                  child:  Text(
                                    "Descrição: " + dados["descricao"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  ),
                                ],
                              )


                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                break;
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _mostraListaCategorias();
        },
      ),
    );
  }
}
