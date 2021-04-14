import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Historico extends StatefulWidget {
  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  int _i = 10;

  StreamController _controller = StreamController.broadcast();
  TextEditingController _controllerQtd = TextEditingController();
  _recuperaPedidos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db
        .collection("entregasRealizadas")
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
                  _i =  int.parse(i);
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
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de entregas"),
        actions: [
          IconButton(
            icon: Icon(Icons.expand),
            color: Colors.white,
            onPressed: (){
              _filtro();
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _controller.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Sem entregas no momento"),
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
                          "Sem pedidos no momento",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    //padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<DocumentSnapshot> requisicoes =
                            querySnapshot.docs.toList();
                        DocumentSnapshot dados = requisicoes[indice];
                        return Card(
                          color: dados["status"] == "entregue"
                              ? Colors.green
                              : Color(0xffFF0000),
                          child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, "/detalhesentrega",
                                    arguments: dados["listaCompras"]);
                              },
                              title: Text(
                                "Cliente: " + dados["nomeUsuario"],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Telefone: " + dados["telefone"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Whatsapp: " + dados["whatsapp"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Endereço: " + dados["endereco"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Bairro: " + dados["bairro"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Ponto de referêcia: " +
                                          dados["pontoReferencia"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Cidade: " + dados["cidade"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Data do pedido: " +
                                          _formatarData(dados["data"]),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Entregue por: " +
                                          dados["nomeEntregador"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Data da entrega: " +
                                          _formatarData(dados["dataEntrega"]),
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
                                ],
                              )),
                        );
                      },
                    ),
                  );
                }
                break;
            }
          }),
    );
  }
}
