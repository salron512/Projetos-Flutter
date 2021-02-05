import 'package:crud/helpers/Helper.dart';
import 'package:crud/model/ModelProdutos.dart';
import 'package:flutter/material.dart';

class Produtos extends StatefulWidget {
  @override
  _ProdutosState createState() => _ProdutosState();
}


class _ProdutosState extends State<Produtos> {
  TextEditingController _nomeControler = TextEditingController();
  TextEditingController _precoControler = TextEditingController();
  TextEditingController _marcacontroller = TextEditingController();
  var _db = Helper();
  List<ModelProdutos> _produtos;



  _telaCadastro({ModelProdutos modelProdutos}) {
    String textoSalvarAtualizar = "";
    if (modelProdutos == null) {
      _nomeControler.text = "";
      _precoControler.text = "";
      _marcacontroller.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      textoSalvarAtualizar = "Atualizar";
      _nomeControler.text = modelProdutos.nome;
      _precoControler.text = modelProdutos.preco;
      _marcacontroller.text = modelProdutos.marca;
    }

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(textoSalvarAtualizar + " Produto"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomeControler,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Nome do produto",
                      hintText: "Digite o nome..."),
                ),
                TextField(
                  keyboardType: TextInputType.number ,
                  controller: _precoControler,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Preço do produto",
                      hintText: "Digite o preço..."),
                ),
                TextField(
                  controller: _marcacontroller,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Marca do produto",
                      hintText: "Digite a marca..."),
                )
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  _salvaAtualizar(produtoSelecionado: modelProdutos);
                  Navigator.pop(context);
                },
                child: Text("$textoSalvarAtualizar"),
              ),
            ],
          );
        }
        );
  }
  _salvaAtualizar( {ModelProdutos produtoSelecionado}) async {

    String nome = _nomeControler.text;
    String preco = _precoControler.text;
    String marca = _marcacontroller.text;

    if(produtoSelecionado == null){
      ModelProdutos produtoSelecionado = ModelProdutos( nome, preco, marca);
      int resultado = await _db.salvar(produtoSelecionado);

    }else{
      produtoSelecionado.nome = nome;
      produtoSelecionado.preco = preco;
      produtoSelecionado.marca = marca;
      int resultado = await _db.atualizar(produtoSelecionado);
    }

    _marcacontroller.clear();
    _precoControler.clear();
    _nomeControler.clear();

    _recuperarProdutos();

  }
  _removerAnotacao(int id) async{

    await _db.remover(id);
    _recuperarProdutos();

  }


  _recuperarProdutos() async{
    List produtosRecuperadas = await _db.recuperar();

    // ignore: deprecated_member_use
    List<ModelProdutos> listaTemporaria = List<ModelProdutos>();

    for(var item in produtosRecuperadas){
     var modelProdutos = ModelProdutos.fromMap(item);
     listaTemporaria.add(modelProdutos);
    }

    setState(() {
      _produtos = listaTemporaria;
    });

    listaTemporaria = null;

    print("recuperar produtos" + produtosRecuperadas.toString());

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarProdutos();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    context;
  }

  @override
  Widget build(context) {
    return Scaffold(
      body:
          _produtos == null ?
              Center(
                child: Text("Sem produtos Cadastratos"),
              )
              :
      Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _produtos.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                final itemLista = _produtos[index];
                return Card(
                  shadowColor: Colors.black,
                  child: ListTile(
                    title: Text(" Produto: "+itemLista.nome),
                    subtitle: Text("Preço R\$ " + itemLista.preco),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: [
                            Text("Marca: " + itemLista.marca)
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(4),
                        ),
                        GestureDetector(
                          onTap: () {
                            _telaCadastro(modelProdutos: itemLista);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _removerAnotacao(itemLista.id);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
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
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _telaCadastro();
        },
      ),
    );
  }
}
