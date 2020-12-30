import 'package:flutter/material.dart';

import 'Home.dart';
import 'Login.dart';


class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch(settings.name){

      case "/" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/login" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/home" :
        return MaterialPageRoute(
            builder: (_) => Home()
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