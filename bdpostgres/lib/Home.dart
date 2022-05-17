import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

TextEditingController _controllerIp = TextEditingController(text: "127.0.0.1");
TextEditingController _controllerLogin = TextEditingController();
TextEditingController _controllerSenha = TextEditingController();
String _ip = _controllerIp.text;
String _erro = '';
String _retorno = '';

FocusNode _focusNode = FocusNode();
late FocusAttachment _focusAttachment;

class _HomeState extends State<Home> {
  // ignore: non_constant_identifier_names
  var connection = PostgreSQLConnection(_ip, 5432, "AppFlutter",
      username: "postgres", password: "postgres");
  int count = 0;
  _AbreConexao() async {
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }
  }

  _Inserir() async {
    String login = _controllerLogin.text;
    String senha = _controllerSenha.text;

    int id = 1;
    if (login.isNotEmpty) {
      if (senha.isNotEmpty) {
        await connection.transaction((ctx) async {
          var result = await ctx.query("select idusuario from usuario");
          ctx.query(
              "INSERT INTO usuario (idusuario,login,senha) VALUES (@id, @login:varchar, @senha:varchar)",
              substitutionValues: {
                'id': result.last[0] + 1,
                'login': login,
                'senha': senha
              });
        });
      } else {
        setState(() {
          _erro = "senha não informado";
        });
      }
    } else {
      setState(() {
        _erro = "login não informado";
      });
    }
  }

  _Presquisa() async {
    //await connection.open();
    //select * from tgerpesquisagrupoparametro
    print('executando');
    List results = await connection.mappedResultsQuery(
        "select dataalteracao, nomegrupo, versaominima from tgerpesquisagrupoparametro");

    for (var row in results) {
      var data = row['tgerpesquisagrupoparametro']['dataalteracao'];

      print(data);
    }
  }

  @override
  void initState() {
    super.initState();
    _AbreConexao();
    _focusAttachment = _focusNode.attach(context, onKeyEvent: (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.f1) {
        setState(() {
          count++;
        });
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _Presquisa();
      }
      return KeyEventResult.handled;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    _focusAttachment.reparent();
    return Scaffold(
      appBar: AppBar(
        title: Text("tdfsdfs"),
      ),
      body: Container(
          child: Column(
        children: [
          Center(child: Text(count.toString())),
          ElevatedButton(
              onPressed: (() {
                setState(() {
                  count++;
                });
              }),
              child: Text("botao"))
        ],
      )),
    );
  }
}
