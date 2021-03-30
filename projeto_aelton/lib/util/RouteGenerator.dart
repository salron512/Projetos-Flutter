import 'package:flutter/material.dart';
import 'package:projeto_aelton/Cadastro.dart';
import 'package:projeto_aelton/Carrinho.dart';
import 'package:projeto_aelton/Login.dart';
import 'package:projeto_aelton/RecuperaSenha.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch(settings.name){

      case "/" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );

      case "/cadastro" :
        return MaterialPageRoute(
            builder: (_) => Cadastro()
        );
      case "/carrinho" :
        return MaterialPageRoute(
            builder: (_) => Carrinho()
        );
      case "/recuperasenha" :
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