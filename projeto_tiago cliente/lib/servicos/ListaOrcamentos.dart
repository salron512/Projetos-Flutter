import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaOrcamentos extends StatefulWidget {
  ListaOrcamentos({Key key}) : super(key: key);

  @override
  _LiscaOrcamentosState createState() => _LiscaOrcamentosState();
}

class _LiscaOrcamentosState extends State<ListaOrcamentos> {
  StreamController _streamController = StreamController.broadcast();

  _recuperaOrcamentos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("reparos")
        .orderBy("data", descending: true)
        .snapshots()
        .listen((event) {
      _streamController.add(event);
    });
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _mostraMsg(DocumentSnapshot dados) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text(""),
            content: Container(
              height: 190,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.asset("images/gear.png"),
                    ),
                  ),
                  Text(
                    "Defina uma ação",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _finalizaEntrega(dados);
                },
                child: Text("Finalizar serviço"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _cancelarEntrega(dados);
                },
                child: Text("Cancelar serviço"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _abrirTelefone(dados["telefone"]);
                },
                child: Text("Ligar para o cliente"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _abrirWhatsApp(dados["whatsapp"]);
                },
                child: Text("Whatsapp do cliente"),
              ),
            ],
          );
        });
  }

  _finalizaEntrega(DocumentSnapshot dados) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Finalizar"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.asset("images/gear.png"),
                    ),
                  ),
                  Text(
                    "Deseja finalizar a ordem de serviço?",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Não"),
              ),
              TextButton(
                child: Text("Sim"),
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
                  db.collection("reparosRealizados").doc().set({
                    "idUsuario": uid,
                    "modeloAparelho": dados["modeloAparelho"],
                    "descricao": dados["descricao"],
                    "nomeUsuario": dados["nomeUsuario"],
                    "telefone": dados["telefone"],
                    "whatsapp": dados["whatsapp"],
                    "endereco": dados["endereco"],
                    "bairro": dados["bairro"],
                    "pontoReferencia": dados["pontoReferencia"],
                    "data": DateTime.now().toString(),
                    "dataSolicitacao": dados["data"]
                  });
                  db.collection("reparos").doc(dados.reference.id).delete();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _abrirWhatsApp(String telefone) async {
    var whatsappUrl = "whatsapp://send?phone=+55$telefone=Olá,tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  _abrirTelefone(String telefone) async {
    var telefoneUrl = "tel:$telefone";

    if (await canLaunch(telefoneUrl)) {
      await launch(telefoneUrl);
    } else {
      throw 'Could not launch $telefoneUrl';
    }
  }

  _cancelarEntrega(DocumentSnapshot dados) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Finalizar"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.asset("images/excluir.png"),
                    ),
                  ),
                  Text(
                    "Deseja realmente excluir a ordem de serviço?",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Não"),
              ),
              TextButton(
                child: Text("Sim"),
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("reparos").doc(dados.reference.id).delete();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaOrcamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitação orçamentos"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        padding: EdgeInsets.only(left: 5, right: 5),
        child: StreamBuilder(
          stream: _streamController.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot querySnapshot = snapshot.data;
                if (querySnapshot.docs.length == 0) {
                  return Center(
                    child: Text(
                      "Sem solicitações no momento",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    // ignore: missing_return
                    itemBuilder: (context, indice) {
                      List<DocumentSnapshot> lista =
                          querySnapshot.docs.toList();
                      DocumentSnapshot dados = lista[indice];
                      return Card(
                        elevation: 8,
                        child: ListTile(
                          title: Text("Cliente: " + dados["nomeUsuario"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Descrição do problema: " +
                                  dados["descricao"]),
                              Text("Aparelho: " + dados["modeloAparelho"]),
                              Text("Sennha do aparelho: " + dados["senha"]),
                              Text("Edereço: " + dados["endereco"]),
                              Text("Bairro: " + dados["bairro"]),
                              Text("Ponto referência: " +
                                  dados["pontoReferencia"]),
                              Text("Data do envio: " +
                                  _formatarData(dados["data"])),
                            ],
                          ),
                          onLongPress: () {
                            _mostraMsg(dados);
                          },
                        ),
                      );
                    },
                  );
                }
                break;
            }
          },
        ),
      ),
    );
  }
}
