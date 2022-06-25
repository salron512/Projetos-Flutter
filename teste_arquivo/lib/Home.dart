// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:teste_arquivo/Model/Produto.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Produto> _listaProdutos = [];
  double _margem = 20;

  Future _selecionaArquivo() async {
    var csvFile = await FilePicker.platform.pickFiles(
        allowedExtensions: ['csv'],
        type: FileType.custom,
        allowMultiple: false);
    //decode bytes back to utf8
    //final csv = utf8.decode(csvFile.files[0].bytes);
    final csv = utf8.decode(csvFile.files[0].bytes);
    var linhas =
        const CsvToListConverter(fieldDelimiter: ';').convert(csv).toList();

    for (var linha in linhas) {
      Produto produto = Produto();
      produto.codBarras = linha[0];
      produto.descricao = linha[1];
      produto.marca = linha[2];
      produto.qtdCotacao = linha[3];
      produto.embalagem = linha[4];
      produto.custoReposicao = linha[5];
      setState(() {
        _listaProdutos.add(produto);
      });
      print(produto.descricao);
      print("item add");
    }

    // User canceled the picker
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de produtos"),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              child: Row(
                children: const [],
              ),
              height: 80,
            )),
      ),
      body: Column(
        children: [
          ListTile(
            // ignore: prefer_const_literals_to_create_immutables
            title: Row(
              children: const [
                Text("Codigo de Barras    "),
                Text("Produto         "),
                Text("Marca          "),
                Text("Quantidade do pedido  "),
                Text("Embalagem  "),
                Text("Custo  ")
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaProdutos.length,
              itemBuilder: (context, indice) {
                Produto produto = _listaProdutos[indice];
                return Card(
                  
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: _margem),
                          // ignore: prefer_interpolation_to_compose_strings
                          child: Text(produto.codBarras.toString() + " "),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: _margem),
                          child: Text(produto.descricao + " "),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: _margem),
                          child: Text(produto.marca + " "),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: _margem),
                          child: Text(produto.qtdCotacao.toString() + " "),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: _margem),
                          child: Text(produto.embalagem + " "),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: _margem),
                          child: Text(
                              "R\$ " + produto.custoReposicao.toString() + " "),
                        )
                      ],
                    ),
                  ),
                  
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _selecionaArquivo();
        },
      ),
    );
  }
}
