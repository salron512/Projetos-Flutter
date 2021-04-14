
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tiago/Adm.dart';
import 'package:projeto_tiago/Carrinho.dart';
import 'package:projeto_tiago/ConfiguracaoUsuario.dart';
import 'package:projeto_tiago/DetalhesEntrega.dart';
import 'package:projeto_tiago/Historico.dart';
import 'package:projeto_tiago/ListaEntregas.dart';
import 'package:projeto_tiago/ListaPedidos.dart';
import 'package:projeto_tiago/ListaProdutos.dart';
import 'package:projeto_tiago/MinhasEntregas.dart';
import 'package:projeto_tiago/PedidoUsuario.dart';
import '../Cadastro.dart';
import '../CadastroProdutos.dart';
import '../Login.dart';
import '../RecuperaSenha.dart';

class RouteGenerator{
  // ignore: missing_return
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
      case "/historico" :
        return MaterialPageRoute(
            builder: (_) => Historico()
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