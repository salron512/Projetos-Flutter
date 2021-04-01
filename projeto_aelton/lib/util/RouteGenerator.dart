import 'package:flutter/material.dart';
import 'package:projeto_aelton/Adm.dart';
import 'package:projeto_aelton/Cadastro.dart';
import 'package:projeto_aelton/Carrinho.dart';
import 'package:projeto_aelton/ConfiguracaoUsuario.dart';
import 'package:projeto_aelton/DetalhesEntrega.dart';
import 'package:projeto_aelton/ListaEntregas.dart';
import 'package:projeto_aelton/ListaPedidos.dart';
import 'package:projeto_aelton/ListaProdutos.dart';
import 'package:projeto_aelton/Login.dart';
import 'package:projeto_aelton/MinhasEntregas.dart';
import 'package:projeto_aelton/PedidoUsuario.dart';
import 'package:projeto_aelton/RecuperaSenha.dart';

import '../CadastroProdutos.dart';

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
      case "/produtos" :
        return MaterialPageRoute(
            builder: (_) => CadastroProdutos()
        );
        case "/config" :
      return MaterialPageRoute(
          builder: (_) => ConfiguracaoUsuario()
      );
      case "/listapedidos" :
        return MaterialPageRoute(
            builder: (_) => ListaPedidos()
        );
      case "/listaprodutos" :
        return MaterialPageRoute(
            builder: (_) => ListaProdutos(args)
        );
      case "/listaentregas" :
        return MaterialPageRoute(
            builder: (_) => ListaEntregas()
        );
      case "/detalhesentrega" :
        return MaterialPageRoute(
            builder: (_) => DetalhesEntrega(args)
        );
      case "/pedidousuario" :
        return MaterialPageRoute(
            builder: (_) => PedidoUsuario()
        );
      case "/minhasentregas" :
        return MaterialPageRoute(
            builder: (_) => MinhasEntregas()
        );
      case "/adm" :
        return MaterialPageRoute(
            builder: (_) => Adm()
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