import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var connection = PostgreSQLConnection("localhost", 5432, "ecodados",
      username: "postgres", password: "postgres");
  // ignore: non_constant_identifier_names

  _Conectar() async {
    await connection.open();
  }

  _Inserir() {
    connection.query(
        "insert into tgerfavoritos  (idpesquisa, usuario, quantidade) values (1, 'André', 1) ");
  }

  _Presquisa() async {
    //select * from tgerpesquisagrupoparametro
    List<List<dynamic>> results = await connection.query(
      "select * from tgerpesquisagrupoparametro",
    );

    for (final row in results) {
      print("resultado " + row.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _Conectar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Iniciar"),
            onPressed: () {
              _Presquisa();
            },
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              child: Text("inserir"),
              onPressed: () {
                _Inserir();
              },
            ),
          )
        ],
      )),
    );
  }
}
