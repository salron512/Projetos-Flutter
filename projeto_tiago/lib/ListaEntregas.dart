import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ListaEntregas extends StatefulWidget {
  bool adm;
  ListaEntregas(this.adm);
  @override
  _ListaEntregasState createState() => _ListaEntregasState();
}

class _ListaEntregasState extends State<ListaEntregas> {
  StreamController _controller = StreamController.broadcast();
  String _uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
  bool _adm = false;

  _recuperaPedidos() async {
    _adm = widget.adm;
    if (_adm) {
      var stream = FirebaseFirestore.instance.collection("listaCompra");

      stream.where("status", isEqualTo: "Recebido").snapshots().listen((event) {
        if (mounted) {
          _controller.add(event);
        }
      });
    } else {
      var stream = FirebaseFirestore.instance.collection("listaCompra");

      stream
          .where("idEntregador", isEqualTo: _uid)
          .where("status", isEqualTo: "Recebido")
          .snapshots()
          .listen((event) {
        if (mounted) {
          _controller.add(event);
        }
      });
    }
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
                      child: Image.asset("images/cart.png"),
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
                child: Text("Finalizar entrega"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _cancelarEntrega(dados);
                },
                child: Text("Cancelar entrega"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _obtemLocalizacao(dados: dados, entrega: true);
                  _enviaAlerta(dados);
                },
                child: Text("Iniciar entrega"),
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
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Text(
                    "Deseja finalizar a entrega?",
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
                onPressed: () async {
                  BackgroundLocation.stopLocationService();
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  await db.collection("pedidosRealizados").doc().set({
                    "idUsuario": dados["idUsuario"],
                    "nomeUsuario": dados["nome"],
                    "nomeEntregador": dados["nomeEntregador"],
                    "telefone": dados["telefone"],
                    "whatsapp": dados["whatsapp"],
                    "endereco": dados["endereco"],
                    "bairro": dados["bairro"],
                    "formaPagamento": dados["formaPagamento"],
                    "status": "Entregue",
                    "cidade": dados["cidade"],
                    "prontoReferencia": dados["prontoReferencia"],
                    "totalCompra": dados["totalCompra"],
                    "listaProdutos": dados["listaProdutos"],
                    "dataEntrega": DateTime.now().toString(),
                    "dataCompra": dados["dataCompra"],
                    "troco": dados["troco"]
                  });

                  await db
                      .collection("listaCompra")
                      .doc(dados.reference.id)
                      .delete();
                  db
                      .collection("localizacaoEntregador")
                      .doc(dados.reference.id)
                      .delete();
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
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Text(
                    "Deseja realmente excluir a entrega?",
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
                onPressed: () async {
                  BackgroundLocation.stopLocationService();
                  String id = dados.reference.id;
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  List<dynamic> listaProduto = dados["listaProdutos"];
                  db.collection("listaCompra").doc(id).delete();
                  db.collection("localizacaoEntregador").doc(id).delete();
                  for (var item in listaProduto) {
                    Map<String, dynamic> dados;
                    int estoque = 0;
                    int qtdCompra = 0;
                    qtdCompra = int.parse(item["quantidade"]).toInt();
                    DocumentSnapshot query = await FirebaseFirestore.instance
                        .collection("produtos")
                        .doc(item["idProduto"])
                        .get();
                    dados = query.data();
                    estoque = dados["quantidade"];
                    estoque = estoque + qtdCompra;
                    print("estoque atualizado" + estoque.toString());
                    FirebaseFirestore.instance
                        .collection("produtos")
                        .doc(item["idProduto"])
                        .update({
                          "quantidade": estoque,
                        });
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _obtemLocalizacao({DocumentSnapshot dados, bool entrega}) async {
    BackgroundLocation.checkPermissions().then((status) {
      print("status Localizacao" + status.toString());
    });

    BackgroundLocation.startLocationService();
    BackgroundLocation.startLocationService(distanceFilter: 1);

    String idEntrega = dados.reference.id;
    FirebaseFirestore db = FirebaseFirestore.instance;
    double latitude;
    double longitude;
    await db
        .collection("listaCompra")
        .doc(idEntrega)
        .update({"entrega": "iniciada"});
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

  _enviaAlerta(DocumentSnapshot dados) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<String> list = [];
    Map<String, dynamic> dadosUsuario = dados.data();
    String idUsuario = dadosUsuario["idUsuario"];

    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(idUsuario).get();

    Map<String, dynamic> map = snapshot.data();
    String idUsuarioNotigicacao = map["playerId"];
    list.add(idUsuarioNotigicacao);
    //sempre que o content for alterado deve-se alterar o metodo _recebeNot
    // que está no arquivo ListaCategorias.dart

    OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: list,
      heading: "Entrega á caminho",
      content: "Sua entrega já foi enviada!",
    ));
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
          title: Text("Entregas em andamento"),
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
                            color: dados["entrega"] == "iniciada"
                                ? Colors.green
                                : Theme.of(context).primaryColor,
                            child: ListTile(
                                onLongPress: () {
                                  _mostraMsg(dados);
                                },
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/detalhesentrega",
                                      arguments: dados["listaProdutos"]);
                                },
                                title: Text(
                                  "Cliente: " + dados["nome"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                        "Cidade: " + dados["cidade"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Ponto de refêrencia: " +
                                            dados["prontoReferencia"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Valor total: R\$ " +
                                            dados["totalCompra"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Forma de pagamento: " +
                                            dados["formaPagamento"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Troco: R\$ " + dados["troco"],
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
                                        "Data da Compra: " +
                                            _formatarData(dados["dataCompra"]),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Entregador: " +
                                            dados["nomeEntregador"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Data de saída: " +
                                            _formatarData(
                                                dados["dataRecebimento"]),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )),
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
