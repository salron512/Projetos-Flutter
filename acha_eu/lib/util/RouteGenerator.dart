import 'package:acha_eu/telas/Adm.dart';
import 'package:acha_eu/telas/Cadastro.dart';
import 'package:acha_eu/telas/Configuracao.dart';
import 'package:acha_eu/telas/Contato.dart';
import 'package:acha_eu/telas/DetalhesAdm.dart';
import 'package:acha_eu/telas/DetalhesContado.dart';
import 'package:acha_eu/telas/DetalhesPedido.dart';
import 'package:acha_eu/telas/DetalhesSugestao.dart';
import 'package:acha_eu/telas/Home.dart';
import 'package:acha_eu/telas/ListaCategorias.dart';
import 'package:acha_eu/telas/ListaPedidos.dart';
import 'package:acha_eu/telas/ListaServicos.dart';
import 'package:acha_eu/telas/ListaSolicitacao.dart';
import 'package:acha_eu/telas/ListaSugestao.dart';
import 'package:acha_eu/telas/ListaTrabalhos.dart';
import 'package:acha_eu/telas/Pagamento.dart';
import 'package:acha_eu/telas/Propaganda.dart';
import 'package:acha_eu/telas/RecuperaSenha.dart';
import 'package:acha_eu/telas/SugestaoUsuario.dart';
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
      case "/recuperasenha" :
        return MaterialPageRoute(
            builder: (_) => RecuperaSenha()
        );
      case "/config" :
        return MaterialPageRoute(
            builder: (_) => Configuracao()
        );
      case "/listaservicos" :
        return MaterialPageRoute(
            builder: (_) => ListaSericos(args)
        );
      case "/detalhescontado" :
        return MaterialPageRoute(
            builder: (_) => DetalhesContado(args)
        );
      case "/contado" :
        return MaterialPageRoute(
            builder: (_) => Contato()
        );
      case "/adm" :
        return MaterialPageRoute(
            builder: (_) => Adm()
        );
      case "/detalhesAdm" :
        return MaterialPageRoute(
            builder: (_) => DetalhesAdm(args)
        );
      case "/listaSugestao" :
        return MaterialPageRoute(
            builder: (_) => ListaSugestao()
        );
      case "/detalhesugestao" :
        return MaterialPageRoute(
            builder: (_) => DetalhesSugestao(args)
        );
      case "/sugestaoUsuario" :
        return MaterialPageRoute(
            builder: (_) => SugestaoUsuario(args)
        );
      case "/listaSolicitacao" :
        return MaterialPageRoute(
            builder: (_) => ListaSolicitacao()
        );
      case "/listaPedidos" :
        return MaterialPageRoute(
            builder: (_) => ListaPedidos(args)
        );
      case "/detalhesPedidos" :
        return MaterialPageRoute(
            builder: (_) => DetalhesPedido(args)
        );
      case "/listaTrabalho" :
        return MaterialPageRoute(
            builder: (_) => ListaTrabalhos()
        );
      case "/propaganda" :
        return MaterialPageRoute(
            builder: (_) => Propaganda()
        );
      case "/pagamento" :
        return MaterialPageRoute(
            builder: (_) => Pagamento()
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

