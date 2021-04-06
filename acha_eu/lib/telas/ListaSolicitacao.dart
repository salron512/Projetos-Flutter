import 'dart:async';
import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
    if (!_controller.hasListener) {
      final stream = db
          .collection("solicitacao")
          .where("idSolicitante", isEqualTo: id)
          .snapshots();
      stream.listen((event) {
        _controller.add(event);
      });
    } else {
      final stream = db
          .collection("solicitacao")
          .where("idSolicitante", isEqualTo: id)
          .orderBy("data", descending: true)
          .snapshots();
      stream.listen((event) {
        _controller.add(event);
      });
    }
  }

  _recuperaCategorias() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var snapshot = await db
        .collection("categorias")
        .orderBy("categoria", descending: false)
        .get();
    List<String> listarecuperada = [];
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
            content: Container(
              width: 100,
              height: 350,
              child: ListView.separated(
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
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/solicitacao.png"),
                    ),
                  ),
                  TextField(
                    controller: _controllerDescricao,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Ex: Preciso de um professor de inglês",
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
      "data": DateTime.now().toString(),
      "status": "Não atendido",
      "telefoneProfissional": " ",
      "nomeProfissional": " ",
      "dataResposta": " "
    }).then((value) {
      _postaNotificao(_usuario.cidade);
    });
  }

  _postaNotificao(String cidade) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<String> list = [];
    var snapshot = await db
        .collection("usuarios")
        .where("cidade", isEqualTo: cidade)
        .where("categoria", isEqualTo: _escolhaCategoria)
        .get();

    for (var item in snapshot.docs) {
      Map<String, dynamic> map = item.data();
      String idUsuarioNotigicacao = map["playerId"];
      list.add(idUsuarioNotigicacao);
    }
    OneSignal.shared.postNotification(OSCreateNotification(
        playerIds: list,
        heading: "Novo trabalho",
        content: "Você tem uma nova prostosta de trabalho!"));
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
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

  _alertDelete(String id) {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar exclusão?"),
            content: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/excluir.png"),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  _recuperaSolicitacao();
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("solicitacao").doc(id).delete();
                  Navigator.pop(context);
                },
                child: Text("Excluir"),
              ),
            ],
          );
        });
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
                  return Container(
                    decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Crie uma solicitação",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  );
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
                          onDismissed: (direcao) async {
                            _alertDelete(dados.reference.id);
                          },
                          key: Key(
                              DateTime.now().millisecondsSinceEpoch.toString()),
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
                          child: Card(
                            color: dados["status"] == "Em atendimento"
                                ? Colors.green
                                : Color(0xff37474f),
                            child: ListTile(
                                title: Text(
                                  "Cliente: " + dados["nome"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Tipo do profissional: " +
                                          dados["categoria"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Descrição: " + dados["descricao"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Status: " + dados["status"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Data da solicitação: " +
                                            _formatarData(dados["data"]),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: dados["nomeProfissional"] == " "
                                          ? Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "Atendido Por: " +
                                                  dados["nomeProfissional"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: dados["dataResposta"] == " "
                                          ? Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "Data da visualização: " +
                                                  _formatarData(
                                                      dados["dataResposta"]),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: dados["telefoneProfissional"] ==
                                              " "
                                          ? Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "Contado: " +
                                                  dados["telefoneProfissional"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                  ],
                                )),
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
