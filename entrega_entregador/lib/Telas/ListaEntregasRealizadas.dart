import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ListaEntregasRealizadas extends StatefulWidget {
  @override
  _ListaEntregasRealizadasState createState() =>
      _ListaEntregasRealizadasState();
}

class _ListaEntregasRealizadasState extends State<ListaEntregasRealizadas> {
  String dropdownValue = '01';
  String dropdownValueAno = '2021';
  double _vlrEntrega = 4;
  int _mes = DateTime.now().month.toInt();
  int _ano = DateTime.now().year.toInt();
  double _totalReceber = 0;
  int _qtd = 0;
  StreamController _streamController = StreamController.broadcast();

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _recuperaEntregas() async {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .where("idEntregador", isEqualTo: uid)
        .where("status", isEqualTo: "Entregue")
        .where("mes", isEqualTo: _mes)
        .where("ano", isEqualTo: _ano)
        .snapshots()
        .listen((event) {
      if (mounted) {
        _streamController.add(event);
        print("teste stream");

        setState(() {
          _qtd = event.docs.length;
          _totalReceber = _vlrEntrega * _qtd;
        });
      }
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
        title: Text("Entregas realizadas"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            Row(
              children: [
                Text("Mês: "),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      _mes = int.parse(dropdownValue).toInt();
                      print(_mes.toString());
                      _recuperaEntregas();
                    });
                  },
                  items: <String>[
                    '01',
                    '02',
                    '03',
                    '04',
                    '05',
                    '06',
                    '07',
                    '08',
                    '09',
                    '10',
                    '11',
                    '12',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10), child: Text("Ano: ")),
                DropdownButton<String>(
                  value: dropdownValueAno,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValueAno = newValue;
                      _ano = int.parse(dropdownValue).toInt();
                    });
                    print(dropdownValueAno);
                    _recuperaEntregas();
                  },
                  items: <String>["2021"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: _streamController.stream,
                // ignore: missing_return
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      QuerySnapshot query = snapshot.data;
                      if (query.docs.isEmpty) {
                        return Center(
                          child: Text("Sem entregas Realizadas"),
                        );
                      } else {
                        return ListView.separated(
                            separatorBuilder: (context, indice) => Divider(
                                  height: 4,
                                  color: Colors.grey,
                                ),
                            itemCount: query.docs.length,
                            // ignore: missing_return
                            itemBuilder: (context, indice) {
                              List<QueryDocumentSnapshot> lista =
                                  query.docs.toList();
                              QueryDocumentSnapshot entrega = lista[indice];
                              return ListTile(
                                title: Text(entrega["nomeEmpresa"]),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Estabelecimento " +
                                          entrega["nomeEmpresa"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Forma de pagamento " +
                                          entrega["formaPagamento"],
                                    ),
                                    Text(
                                      "Troco R\$ " + entrega["troco"],
                                    ),
                                    Text(
                                      "Valor total R\$ " +
                                          entrega["totalPedido"],
                                    ),
                                    Text(
                                      "Endereço " + entrega["enderecoUsuario"],
                                    ),
                                    Text(
                                      "Bairro " + entrega["bairroUsuario"],
                                    ),
                                    Text(
                                      "Hora do pedido " +
                                          _formatarData(entrega["horaPedido"]),
                                    ),
                                    Text(
                                      "Status " + entrega["status"],
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                      break;
                  }
                },
              ),
            ),
            Card(
                color: Theme.of(context).primaryColor,
                child: ListTile(
                    title: Text(
                      "Total",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Valor por entrega R\$ " +
                              _vlrEntrega.toStringAsFixed(2),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Valor a receber R\$ " +
                              _totalReceber.toStringAsFixed(2),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Quantidade total de entregas " + _qtd.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    contentPadding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5)))
          ],
        ),
      ),
    );
  }
}
