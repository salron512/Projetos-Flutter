import 'package:entrega/Telas/AlteraCadastro.dart';
import 'package:entrega/Telas/AlteraCadastroEmpresa.dart';
import 'package:entrega/Telas/CadastraImagemPerfilEmpresa.dart';
import 'package:entrega/Telas/Cadastro.dart';
import 'package:entrega/Telas/CadastroEmpresa.dart';
import 'package:entrega/Telas/Home.dart';
import 'package:entrega/Telas/ListaEmpresas.dart';
import 'package:entrega/Telas/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rotas {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());

      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());

      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/alteracadastro":
        return MaterialPageRoute(builder: (_) => AlteraCadastro());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/cadastroEmpresa":
        return MaterialPageRoute(builder: (_) => CadastroEmpresa());
      case "/cadastroperfil":
        return MaterialPageRoute(
            builder: (_) => CadastraImagemPerfilEmpresa(args));
      case "/listaempresas":
        return MaterialPageRoute(builder: (_) => ListaEmpressas(args));
      case "/alteracadastroempresa":
        return MaterialPageRoute(builder: (_) => AlteraCadastroEmpresa());

      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não Encontrada"),
        ),
        body: Center(
          child: Text("Tela não Encontrada"),
        ),
      );
    });
  }
}
