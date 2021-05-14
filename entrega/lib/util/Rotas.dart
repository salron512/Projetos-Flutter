import 'package:entrega/Telas/Cadastro.dart';
import 'package:entrega/Telas/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rotas {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

  switch(settings.name){
     case "/":
        return MaterialPageRoute(builder: (_) => Login());
        case "/cadastro":
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
