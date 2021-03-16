import 'package:acha_eu/telas/Cadastro.dart';
import 'package:acha_eu/telas/Home.dart';
import 'package:acha_eu/telas/ListaCategorias.dart';
import 'package:acha_eu/telas/RecuperaSenha.dart';
import 'package:flutter/material.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch(settings.name){

      case "/" :
        return MaterialPageRoute(
          builder: (_) => Home()
        );
        case "/cadastro" :
        return MaterialPageRoute(
          builder: (_) => Cadastro()
        );
      case "/listacategorias" :
        return MaterialPageRoute(
            builder: (_) => ListaCategorias()
        );
      case "/recupearasenha" :
        return MaterialPageRoute(
            builder: (_) => RecuperaSenha()
        );
      
      default:
        _erroRota();
    }
  }
    static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não Encontrada"),
          ),
          body: Center(
            child: Text("Tela não Encontrada"),
          ),
        );
      }
    );
    }
}