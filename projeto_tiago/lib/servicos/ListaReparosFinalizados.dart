import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ListaReparosFinalizados extends StatefulWidget {
  ListaReparosFinalizados({Key key}) : super(key: key);

  @override
  _ListaReparosFinalizadosState createState() => _ListaReparosFinalizadosState();
}

class _ListaReparosFinalizadosState extends State<ListaReparosFinalizados> {
  int _i = 10;

  StreamController _controller = StreamController.broadcast();
  TextEditingController _controllerQtd = TextEditingController();
  _recuperaPedidos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db
        .collection("reparosRealizados")
        .limit(_i)
        .orderBy("data", descending: true)
        .snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _filtro() {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Filtro lista"),
            content: Container(
              width: 100,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/gear.png"),
                    ),
                  ),
                  TextField(
                    controller: _controllerQtd,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Digite a quantidade a ser exibida",
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    String i = _controllerQtd.text;
                    int.parse(i);
                    _i = int.parse(i);
                  });
                  Navigator.pop(context);
                  _recuperaPedidos();
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaPedidos();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reparos realizados"),
         actions: [
            IconButton(
              icon: Icon(Icons.expand),
              color: Colors.white,
              onPressed: () {
                _filtro();
              },
            ),
          ],
      ),
      body: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          child: StreamBuilder(
              stream: _controller.stream,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sem pedidos no momento",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        // ignore: missing_return
                        itemBuilder: (context, indice) {
                          List<DocumentSnapshot> requisicoes =
                              querySnapshot.docs.toList();
                          DocumentSnapshot dados = requisicoes[indice];
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
                              Text("Edereço: " + dados["endereco"]),
                              Text("Bairro: " + dados["bairro"]),
                              Text("Ponto Referência: " + dados["pontoReferencia"]),
                              Text("Data do Entrega: " + _formatarData(dados["data"])),
                              Text("Data do Envio: " + _formatarData(dados["dataSolicitacao"])),
                            ],
                          ),
                        ),
                      );
                        },
                      );
                    }
                    break;
                }
              }),
        ));
       

  }
}