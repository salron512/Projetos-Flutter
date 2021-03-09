import 'package:flutter/material.dart';
import 'package:uber/telas/Cadastro.dart';
import 'package:uber/telas/Home.dart';
import 'package:uber/telas/PainelMotorista.dart';
import 'package:uber/telas/PainelPassageiro.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Home());
      case "/Home":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/PainelMotorista":
        return MaterialPageRoute(builder: (_) => PainelMotorista());
      case "/PainelPassageiro":
        return MaterialPageRoute(builder: (_) => PainelPassageiro());
      case "/Cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
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
