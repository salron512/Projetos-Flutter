import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tiago/Adm.dart';
import 'package:projeto_tiago/AdmEntregador.dart';
import 'package:projeto_tiago/CadastraCategorias.dart';
import 'package:projeto_tiago/Carrinho.dart';
import 'package:projeto_tiago/Categorias.dart';
import 'package:projeto_tiago/ConfiguracaoUsuario.dart';
import 'package:projeto_tiago/DetalhesEntrega.dart';
import 'package:projeto_tiago/DetalhesProdutos.dart';
import 'package:projeto_tiago/GriProduto.dart';
import 'package:projeto_tiago/Grid.dart';
import 'package:projeto_tiago/Historico.dart';
import 'package:projeto_tiago/Imagem.dart';
import 'package:projeto_tiago/ListaCategorias.dart';
import 'package:projeto_tiago/ListaCompras.dart';
import 'package:projeto_tiago/ListaEntregas.dart';
import 'package:projeto_tiago/ListaPedidos.dart';
import 'package:projeto_tiago/ListaProdutos.dart';
import 'package:projeto_tiago/Mapa.dart';
import 'package:projeto_tiago/MinhasEntregas.dart';
import 'package:projeto_tiago/PedidoUsuario.dart';
import 'package:projeto_tiago/PerfilCategoria.dart';
import 'package:projeto_tiago/servicos/ListaOrcamentos.dart';
import 'package:projeto_tiago/servicos/ListaReparosFinalizados.dart';
import 'package:projeto_tiago/servicos/SolicitaReparo.dart';
import '../Cadastro.dart';
import '../CadastroProdutos.dart';
import '../Login.dart';
import '../RecuperaSenha.dart';

class RouteGenerator {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());

      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/carrinho":
        return MaterialPageRoute(builder: (_) => Carrinho(args));
      case "/recuperasenha":
        return MaterialPageRoute(builder: (_) => RecuperaSenha());
      case "/produtos":
        return MaterialPageRoute(builder: (_) => CadastroProdutos());
      case "/config":
        return MaterialPageRoute(builder: (_) => ConfiguracaoUsuario());
      case "/listapedidos":
        return MaterialPageRoute(builder: (_) => ListaPedidos());
      case "/listaprodutos":
        return MaterialPageRoute(builder: (_) => ListaProdutos(args));
      case "/listaentregas":
        return MaterialPageRoute(builder: (_) => ListaEntregas(args));
      case "/detalhesentrega":
        return MaterialPageRoute(builder: (_) => DetalhesEntrega(args));
      case "/pedidousuario":
        return MaterialPageRoute(builder: (_) => PedidoUsuario());
      case "/minhasentregas":
        return MaterialPageRoute(builder: (_) => MinhasEntregas());
      case "/adm":
        return MaterialPageRoute(builder: (_) => Adm());
      case "/historico":
        return MaterialPageRoute(builder: (_) => Historico());
      case "/produto":
        return MaterialPageRoute(builder: (_) => DetalhesProdutos());
      case "/grid":
        return MaterialPageRoute(builder: (_) => GridProduto(args));
      case "/gridproduto":
        return MaterialPageRoute(builder: (_) => Grid(args));
      case "/imagem":
        return MaterialPageRoute(builder: (_) => Imagem(args));
      case "/listaCompras":
        return MaterialPageRoute(builder: (_) => ListaCompras());
      case "/reparo":
        return MaterialPageRoute(builder: (_) => SolicitaReparo());
      case "/listaorcamento":
        return MaterialPageRoute(builder: (_) => ListaOrcamentos());
      case "/listaservicosfinal":
        return MaterialPageRoute(builder: (_) => ListaReparosFinalizados());
         case "/listacategorias":
        return MaterialPageRoute(builder: (_) => ListaCategorias());
          case "/cadastracategorias":
        return MaterialPageRoute(builder: (_) => CadastraCategoias());
           case "/perfilcategoria":
        return MaterialPageRoute(builder: (_) => PerfilCategoria(args));
           case "/categoria":
        return MaterialPageRoute(builder: (_) => Categorias());
           case "/entregador":
        return MaterialPageRoute(builder: (_) => AdmEntregador());
          case "/mapa":
        return MaterialPageRoute(builder: (_) => Mapa(args));


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
