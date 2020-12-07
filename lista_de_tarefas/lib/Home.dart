import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> _ultimoTarefaRemovida = Map();
  TextEditingController _controllerTarefa = TextEditingController();
  List _listaTarefas = [];

  Future<File> _getFile() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}dados.json");
  }

  _salvarArquivo()async{

   var arquivo  = await _getFile();
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);

  }

  _salvarTarefa(){
    String textoDigitado = _controllerTarefa.text;
    Map<String, dynamic> tarefas = Map();
    tarefas["titulo"] = textoDigitado;
    tarefas["realizada"] = false;
   setState(() {
     _listaTarefas.add(tarefas);
   });
    _salvarArquivo();
  _controllerTarefa.text = "";
  }

  _lerArquivo()async{
    try{

      final arquivo = await _getFile();
       return arquivo.readAsString();

    }catch(e){
      return null;
    }
  }
@override
  void initState() {
    super.initState();
    _lerArquivo().then( (dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    }
    );
  }

  Widget criarItemLista( context, index){
    final item = _listaTarefas[index].toString();

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.all(8),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:<Widget> [
            Icon(Icons.delete, color: Colors.white,),
          ],
        )
      ),
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      onDismissed: (direcao){
        _ultimoTarefaRemovida = _listaTarefas[index];
        _listaTarefas.removeAt(index);
        _salvarArquivo();

        final snackBar = SnackBar(
          content: Text("Tarrefa removida"),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: (){
             setState(() {
               _listaTarefas.insert(index, _ultimoTarefaRemovida);
             });
              _salvarArquivo();
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: CheckboxListTile(
        activeColor: Colors.purple,
        title: Text( _listaTarefas[index]["titulo"]),
        value: _listaTarefas[index]["realizada"],
        onChanged: (valorAlterado){
          setState(() {_listaTarefas[index]["realizada"] = valorAlterado;
          });
          _salvarArquivo();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Lista de tarefas"),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed:(){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text("Adicionar Tarefa"),
                content: TextField(
                  controller: _controllerTarefa,
                  decoration: InputDecoration(
                    labelText: "Digite sua tarefa"
                  ),
                  onChanged: (text){},
                ),
                actions:<Widget> [
                  FlatButton(
                    child: Text("Cancelar"),
                    onPressed: (){
                  _controllerTarefa.text = "";
                  Navigator.pop(context);
              }
                  ),
                  FlatButton(
                    child: Text("Salvar"),
                    onPressed: (){
                      _salvarTarefa();
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child:  Column(
          children: [
           Expanded(
             child: ListView.builder(
               itemCount: _listaTarefas.length,
               // ignore: missing_return
               itemBuilder: criarItemLista
             ),
           )
          ],
        ),
      )
    );
  }
}
