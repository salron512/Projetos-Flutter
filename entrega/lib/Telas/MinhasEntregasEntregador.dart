import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MinhasEntregasEntregador extends StatefulWidget {
  @override
  _MinhasEntregasEntregadorState createState() =>
      _MinhasEntregasEntregadorState();
}

class _MinhasEntregasEntregadorState extends State<MinhasEntregasEntregador> {
  StreamController _streamController = StreamController.broadcast();

  _recuperaEntregas() {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .where("idEntregador", isEqualTo: uid)
        .where("andamento", isEqualTo: true)
        .snapshots()
        .listen((event) {
      if (mounted) {
        _streamController.add(event);
      }
    });
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _selecionaOpcao(QueryDocumentSnapshot entrega) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selecione uma ação"),
            content: Container(
              width: 80,
              height: 80,
              child: Image.asset("images/food-delivery.png"),
            ),
            actions: [
              TextButton(
                child: Text("Cancelar entrega"),
                onPressed: () {
                  Navigator.pop(context);
                  _cancelaEntrega(entrega);
                },
              ),
              TextButton(
                child: Text("Iniciar entrega"),
                onPressed: () {
                  Navigator.pop(context);
                  _obtemLocalizacao(entrega);
                },
              ),
              TextButton(
                child: Text("Finalizar entrega"),
                onPressed: () {
                  Navigator.pop(context);
                  _finalizaPedido(entrega);
                },
              ),
              TextButton(
                child: Text("Telefone cliente"),
                onPressed: () {},
              ),
              TextButton(
                child: Text("Whatsapp cliente"),
                onPressed: () {},
              ),
            ],
          );
        });
  }

  _cancelaEntrega(QueryDocumentSnapshot entrega) {
    TextEditingController controllerMotivo = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar Cancelamento"),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.url,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Motivo",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: controllerMotivo),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Confirmar"),
                onPressed: () {
                  if (controllerMotivo.text.isNotEmpty) {
                    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();

                    FirebaseFirestore.instance
                        .collection("pedidos")
                        .doc(entrega.reference.id)
                        .update({
                      "IdUsuarioCancelamento": uid,
                      "andamento": false,
                      "status": "Cancelada",
                      "motivo": controllerMotivo.text,
                      "dataCancelamento": DateTime.now().toString()
                    }).then((value) {
                      BackgroundLocation.stopLocationService();
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  _finalizaPedido(QueryDocumentSnapshot entrega) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Finaliza pedido"),
            content: Container(
              height: 200,
              child: Column(
                children: [],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Confirmar"),
                onPressed: () {
                  String mes = DateTime.now().month.toString();
                  String ano = DateTime.now().year.toString();
                  FirebaseFirestore.instance
                      .collection("pedidos")
                      .doc(entrega.reference.id)
                      .update({
                    "andamento": false,
                    "mes": mes,
                    "ano": ano,
                    "status": "Finalizada",
                    "dataEntrega": DateTime.now().toString()
                  }).then((value) {
                    BackgroundLocation.stopLocationService();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  _obtemLocalizacao(DocumentSnapshot dados) async {
    bool permisao = await Permission.location.isRestricted;
    if (permisao) {
      BackgroundLocation.checkPermissions();
    }
    BackgroundLocation.startLocationService();
    BackgroundLocation.startLocationService(distanceFilter: 1);

    String idEntrega = dados.reference.id;
    FirebaseFirestore db = FirebaseFirestore.instance;
    double latitude;
    double longitude;
    await FirebaseFirestore.instance
        .collection("pedidos")
        .doc(idEntrega)
        .update({"status": "Iniciada"});

    BackgroundLocation.getLocationUpdates((location) {
      print(location);
      latitude = location.latitude;
      longitude = location.longitude;
      db
          .collection("localizacaoEntregador")
          .doc(idEntrega)
          .set({"latitude": latitude, "longitude": longitude});
      print("EXECUTANDO!!!!!");
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaEntregas();
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
        title: Text("Minhas entregas"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _streamController.stream,
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
                    child: Text("Sem entregas no momento"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    // ignore: missing_return
                    itemBuilder: (context, indice) {
                      List<QueryDocumentSnapshot> lista =
                          querySnapshot.docs.toList();
                      QueryDocumentSnapshot entrega = lista[indice];
                      return Card(
                        elevation: 8,
                        child: ListTile(
                          title: Text("Cliente " + entrega["cliente"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Estabelecimento " + entrega["nomeEmpresa"]),
                              Text("Forma de pagamento " +
                                  entrega["formaPagamento"]),
                              Text("Troco R\$ " + entrega["troco"]),
                              Text("Valor total R\$ " + entrega["totalPedido"]),
                              Text("Endereço " + entrega["enderecoUsuario"]),
                              Text("Bairro " + entrega["bairroUsuario"]),
                              Text("Hora do pedido " +
                                  _formatarData(entrega["horaPedido"])),
                              Text("Status " + entrega["status"])
                            ],
                          ),
                          onLongPress: () {
                            _selecionaOpcao(entrega);
                          },
                          onTap: () {
                            Navigator.pushNamed(context, "/detalhesentrega",
                                arguments: entrega["listaPedido"]);
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
