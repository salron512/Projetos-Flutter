import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Financeiro extends StatefulWidget {
  @override
  _FinanceiroState createState() => _FinanceiroState();
}

class _FinanceiroState extends State<Financeiro> {
  StreamController _streamController = StreamController.broadcast();
  String dropdownValue = '01';
  String dropdownValueAno = '2021';

  int _mes = DateTime.now().month.toInt();
  int _ano = DateTime.now().year.toInt();
  double _resultado = 0;
  double _vlrEntrega = 0;
  double _totalReceber = 0;
  double _totalPagar = 0;
  double _taxa = 0.05;
  int _qtd = 0;
  String _empresa = "";
  List<String> _listaEmpresas = [];

  _recuperaEntregas() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("pedidos");

    if (_empresa.isEmpty) {
      reference
          .where("status", isEqualTo: "Entregue")
          .where("mes", isEqualTo: _mes)
          .where("ano", isEqualTo: _ano)
          .snapshots()
          .listen((event) {
        if (mounted) {
          _streamController.add(event);
          print("teste stream");
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
            _resultado = _resultado + _vlrEntrega;
          });
          setState(() {
            _qtd = event.docs.length;
            _totalReceber = _resultado;
            _totalPagar = _resultado * _taxa;
          });
        }
      });
    } else {
      reference
          .where("nomeEmpresa", isEqualTo: _empresa)
          .where("status", isEqualTo: "Entregue")
          .where("mes", isEqualTo: _mes)
          .where("ano", isEqualTo: _ano)
          .snapshots()
          .listen((event) {
        if (mounted) {
          _streamController.add(event);
          print("teste stream");
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
            _resultado = _resultado + _vlrEntrega;
          });
          setState(() {
            _qtd = event.docs.length;
            _totalReceber = _resultado;
            _totalPagar = _resultado * _taxa;
          });
        }
      });
      print("teste ok");
    }
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _recuperaEmpresas() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("usuarios");

    QuerySnapshot querySnapshot = await reference
        .orderBy("nomeFantasia", descending: false)
        .where("tipoUsuario", isEqualTo: "empresa")
        .where("ativa", isEqualTo: true)
        .get();
    for (var item in querySnapshot.docs) {
      Map<String, dynamic> dadosEmpresa = item.data();
      String nomeEmpresa = dadosEmpresa["nomeFantasia"];
      _listaEmpresas.add(nomeEmpresa);
    }
  }

  _alertListaEmpresas() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selecione uma empresa"),
            content: Container(
                height: 150,
                width: 100,
                child: ListView.builder(
                    itemCount: _listaEmpresas.length,
                    // ignore: missing_return
                    itemBuilder: (context, indice) {
                      String empresa = _listaEmpresas[indice];
                      return ListTile(
                        title: Text(empresa),
                        onTap: () {
                          setState(() {
                            _empresa = empresa;
                          });
                          _recuperaEntregas();
                          Navigator.pop(context);
                        },
                      );
                    })),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _empresa = "";
                    });
                    _recuperaEntregas();
                    Navigator.pop(context);
                  },
                  child: Text("Limpar"))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperaEntregas();
    _recuperaEmpresas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financeiro"),
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
                IconButton(
                    onPressed: () {
                      _alertListaEmpresas();
                    },
                    icon: Icon(Icons.business)),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(_empresa),
                )
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
                                title:
                                    Text("Cliente " + entrega["nomeEmpresa"]),
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
                          "Valor total entregas R\$ " +
                              _totalReceber.toStringAsFixed(2),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Valor total á pagar R\$ " +
                              _totalPagar.toStringAsFixed(2),
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
