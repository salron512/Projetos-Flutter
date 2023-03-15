import 'package:flutter/material.dart';
import 'package:via_ponto/Home.dart';
import 'package:via_ponto/Login.dart';

class Rotas {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments as dynamic;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());

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
