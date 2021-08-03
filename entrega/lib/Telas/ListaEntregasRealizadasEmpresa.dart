import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ListaEntregasRealizadasEmpresa extends StatefulWidget {
  @override
  _ListaEntregasRealizadasEmpresaState createState() =>
      _ListaEntregasRealizadasEmpresaState();
}

class _ListaEntregasRealizadasEmpresaState
    extends State<ListaEntregasRealizadasEmpresa> {
  String dropdownValue = '01';
  String dropdownValueAno = '2021';
  String dropdownValueStatus = 'Entregue';
  String _status = 'Entregue';

  int _mes = DateTime.now().month.toInt();
  int _ano = DateTime.now().year.toInt();
  double _resultado = 0;
  double _vlrEntrega = 0;
  double _totalReceber = 0;
  double _totalPagar = 0;
  double _taxaEntrega = 4;
  double _totalEntrega = 0;
  double _totalFinal = 0;
  double _taxa = 0.05;
  int _qtd = 0;
  StreamController _streamController = StreamController.broadcast();

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    DateFormat formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _recuperaEntregas() async {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    reference
        .orderBy("horaPedido", descending: false)
        .where("idEmpresa", isEqualTo: uid)
        .where("status", isEqualTo: _status)
        .where("mes", isEqualTo: _mes)
        .where("ano", isEqualTo: _ano)
        .snapshots()
        .listen((event) {
      if (mounted) {
        _streamController.add(event);
      }
      setState(() {
        _resultado = 0;
        _vlrEntrega = 0;
        _totalReceber = 0;
        _totalPagar = 0;
        _qtd = 0;
      });
      event.docs.forEach((element) {
        Map<String, dynamic> dados = element.data();
        _vlrEntrega = double.tryParse(dados["totalPedido"]).toDouble();
        print("valor " + _vlrEntrega.toString());
        _vlrEntrega -= _taxaEntrega;
        _resultado += _vlrEntrega;
      });
      setState(() {
        _qtd = event.docs.length;
        _totalReceber = _resultado;

        _totalPagar = _resultado * _taxa;
        _totalEntrega = _taxaEntrega * _qtd;
        _totalFinal = _totalPagar + _totalEntrega;
      });
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

                    //print(dropdownValue);
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
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Status: ")),
                DropdownButton<String>(
                  value: dropdownValueStatus,
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
                      _status = newValue;
                      dropdownValueStatus = newValue;
                      print(newValue);
                    });
                    _recuperaEntregas();
                  },
                  items: <String>["Entregue", 'Cancelada']
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
                          child: Text("Sem entregas realizadas"),
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
                                      "Entregue por " +
                                          entrega["nomeEntregador"],
                                    ),
                                     Text(
                                          "Valor total sem taxa R\$ " +
                                              entrega["totalSemTaxa"],
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
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/detalhesentrega",
                                      arguments: entrega["listaPedido"]);
                                },
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
                        "Valor total entregas R\$ " +
                            _totalReceber.toStringAsFixed(2),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Quantidade total de entregas " + _qtd.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Total á pagar entregas R\$ " +
                            _totalEntrega.toStringAsFixed(2),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Valor total á pagar R\$ " +
                            _totalFinal.toStringAsFixed(2),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  contentPadding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                ))
          ],
        ),
      ),
    );
  }
}
