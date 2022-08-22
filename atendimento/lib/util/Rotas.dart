import 'package:atendimento/Entrar.dart';
import 'package:atendimento/Home.dart';
import 'package:atendimento/ListaCheckList.dart';
import 'package:atendimento/Modulos.dart';
import 'package:atendimento/RecuperarSenha.dart';
import 'package:flutter/material.dart';

class Rotas {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments as dynamic;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Entrar());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/recuperaSenha":
        return MaterialPageRoute(builder: (_) => RecuperarSenha());
        case "/modulos":
        return MaterialPageRoute(builder: (_) => Modulos(args));
         case "/checkList":
        return MaterialPageRoute(builder: (_) => ListaCheckList(args));

      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text("Tela não Encontrada"),
                  ),
                ));
    }
  }
}
