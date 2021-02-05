import 'package:crud/model/ModelClientes.dart';
import 'package:flutter/material.dart';
import 'helpers/Helper.dart';

class Cliente extends StatefulWidget {
  @override
  _ClienteState createState() => _ClienteState();
}

class _ClienteState extends State<Cliente> {

  TextEditingController _nomeControler = TextEditingController();
  TextEditingController _enderecoControler = TextEditingController();
  TextEditingController _telefonecontroller = TextEditingController();
  var _db = Helper();
  List<ModelClientes> _clientes;



  _telaCadastro({ModelClientes modelClientes}) {
    String textoSalvarAtualizar = "";
    if (modelClientes == null) {
      _nomeControler.text = "";
      _enderecoControler.text = "";
      _telefonecontroller.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      textoSalvarAtualizar = "Atualizar";
      _nomeControler.text = modelClientes.nome;
      _enderecoControler.text = modelClientes.endereco;
      _telefonecontroller.text = modelClientes.telefone;
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
                      labelText: "Nome do nome",
                      hintText: "Digite o nome..."),
                ),
                TextField(
                  keyboardType: TextInputType.text ,
                  controller: _enderecoControler,
                  decoration: InputDecoration(
                      labelText: "Endereço",
                      hintText: "Digite o endereco..."),
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: _telefonecontroller,
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
                  _salvaAtualizar(clienteSelecionado: modelClientes);
                  Navigator.pop(context);
                },
                child: Text("$textoSalvarAtualizar"),
              ),
            ],
          );
        }
    );
  }
  _salvaAtualizar( {ModelClientes clienteSelecionado}) async {

    String nome = _nomeControler.text;
    String endereco = _enderecoControler.text;
    String telefone = _telefonecontroller.text;

    if(clienteSelecionado == null){
      ModelClientes clienteSelecionado = ModelClientes(nome, endereco, telefone);
      int resultado = await _db.salvarClientes(clienteSelecionado);

    }else{
      clienteSelecionado.nome = nome;
      clienteSelecionado.endereco = endereco;
      clienteSelecionado.telefone = telefone;
      int resultado = await _db.atualizarClientes(clienteSelecionado);
    }

    _enderecoControler.clear();
    _telefonecontroller.clear();
    _nomeControler.clear();

    _recuperarClientes();

  }
  _recuperarClientes() async{
    List produtosRecuperadas = await _db.recuperarClientes();

    // ignore: deprecated_member_use
    List<ModelClientes> listaTemporaria = List<ModelClientes>();

    for(var item in produtosRecuperadas){
      var modelProdutos = ModelClientes.fromMap(item);
      listaTemporaria.add(modelProdutos);
    }

    setState(() {
      _clientes = listaTemporaria;
    });

    listaTemporaria = null;

    print("recuperar produtos" + produtosRecuperadas.toString());

  }
  _removerAnotacao(int id) async{

    await _db.removerClientes(id);
    _recuperarClientes();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarClientes();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
   body: _clientes == null ?
    Center(
      child: Text("Sem produtos Cadastratos"),
    )
        :
    Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _clientes.length,
            // ignore: missing_return
            itemBuilder: (context, index) {
              final itemLista = _clientes[index];
              return Card(
                shadowColor: Colors.black,
                child: ListTile(

                  title: Text("Nome: " +itemLista.nome),
                  subtitle: Text("Endereço: " + itemLista.endereco),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: [
                          Text("telefone: " + itemLista.telefone)
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(4),
                      ),
                      GestureDetector(
                        onTap: () {
                          _telaCadastro(modelClientes: itemLista);
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
