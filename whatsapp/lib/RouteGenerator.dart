import 'package:flutter/material.dart';
import 'package:whatsapp/Cadastro.dart';
import 'package:whatsapp/Configuracao.dart';
import 'package:whatsapp/Home.dart';
import 'package:whatsapp/Login.dart';


class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){

    switch(settings.name){

      case "/" :
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case "/login" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "cadastro" :
        return MaterialPageRoute(
            builder: (_) => Cadastro()
        );
      case "/home" :
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case "/config" :
        return MaterialPageRoute(
            builder: (_) => Configuracao()
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