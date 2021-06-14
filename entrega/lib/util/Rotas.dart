import 'package:entrega/Telas/AlteraCadastro.dart';
import 'package:entrega/Telas/AlteraCadastroEmpresa.dart';
import 'package:entrega/Telas/CadastraImagemPerfilEmpresa.dart';
import 'package:entrega/Telas/Cadastro.dart';
import 'package:entrega/Telas/CadastroEmpresa.dart';
import 'package:entrega/Telas/CadastroEntregador.dart';
import 'package:entrega/Telas/CadastroProdutos.dart';
import 'package:entrega/Telas/Carrinho.dart';
import 'package:entrega/Telas/DetalhesEntrega.dart';
import 'package:entrega/Telas/Financeiro.dart';
import 'package:entrega/Telas/Home.dart';
import 'package:entrega/Telas/ListaEmpresaCadastro.dart';
import 'package:entrega/Telas/ListaEmpresas.dart';
import 'package:entrega/Telas/ListaEntregadores.dart';
import 'package:entrega/Telas/ListaEntregasPendentes.dart';
import 'package:entrega/Telas/ListaEntregasRealizadas.dart';
import 'package:entrega/Telas/ListaEntregasRealizadasEmpresa.dart';
import 'package:entrega/Telas/ListaPedidosEmpresa.dart';
import 'package:entrega/Telas/ListaPedidosUsuario.dart';
import 'package:entrega/Telas/ListaProdutos.dart';
import 'package:entrega/Telas/ListaProdutosUsuario.dart';
import 'package:entrega/Telas/Login.dart';
import 'package:entrega/Telas/Mapa.dart';
import 'package:entrega/Telas/MinhasEntregasEntregador.dart';
import 'package:entrega/Telas/PerfilProduto.dart';
import 'package:entrega/Telas/RecuperaSenha.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rotas {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());

      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());

      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/alteracadastro":
        return MaterialPageRoute(builder: (_) => AlteraCadastro());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/cadastroEmpresa":
        return MaterialPageRoute(builder: (_) => CadastroEmpresa());
      case "/cadastroperfil":
        return MaterialPageRoute(
            builder: (_) => CadastraImagemPerfilEmpresa(args));
      case "/listaempresas":
        return MaterialPageRoute(builder: (_) => ListaEmpressas(args));
      case "/alteracadastroempresa":
        return MaterialPageRoute(builder: (_) => AlteraCadastroEmpresa());
      case "/listaprodutos":
        return MaterialPageRoute(builder: (_) => ListaProdutos());
      case "/cadastroproduto":
        return MaterialPageRoute(builder: (_) => CadastraProdutos());
      case "/perfilproduto":
        return MaterialPageRoute(builder: (_) => PerfilProduto(args));
      case "/listaprodutosusuario":
        return MaterialPageRoute(builder: (_) => ListaProdutosUsuario(args));
      case "/carinho":
        return MaterialPageRoute(builder: (_) => Carrinho(args));
      case "/cadastroentregador":
        return MaterialPageRoute(builder: (_) => CadastroEntregador());
      case "/listapedidousuario":
        return MaterialPageRoute(builder: (_) => ListaPedidosUsuario());
      case "/detalhesentrega":
        return MaterialPageRoute(builder: (_) => DetalhesEntrega(args));
      case "/listaEntregadores":
        return MaterialPageRoute(builder: (_) => ListaEntregadores());
      case "/listaEntregaPedentes":
        return MaterialPageRoute(builder: (_) => ListEntregasPendentes());
      case "/minhasentregas":
        return MaterialPageRoute(builder: (_) => MinhasEntregasEntregador());
      case "/mapa":
        return MaterialPageRoute(builder: (_) => Mapa(args));
      case "/entregasrealizadas":
        return MaterialPageRoute(builder: (_) => ListaEntregasRealizadas());
      case "/listapedidosempresa":
        return MaterialPageRoute(builder: (_) => ListaPedidosEmpresa());
      case "/listaentregasrealizadasempresa":
        return MaterialPageRoute(
            builder: (_) => ListaEntregasRealizadasEmpresa());
      case "/financeiro":
        return MaterialPageRoute(builder: (_) => Financeiro());
      case "/reset":
        return MaterialPageRoute(builder: (_) => RecuperaSenha());
          case "/listaempresacadastro":
        return MaterialPageRoute(builder: (_) => ListaEmpresaCadastro());

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
