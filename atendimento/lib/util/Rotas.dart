import 'package:atendimento/Entrar.dart';
import 'package:atendimento/Home.dart';
import 'package:flutter/material.dart';

class Rotas {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Entrar());
        case "/home":
        return MaterialPageRoute(builder: (_) => Home());


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
