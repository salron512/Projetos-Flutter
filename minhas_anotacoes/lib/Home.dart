import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:intl/intl.dart';
import 'helper/AnotacaoHelper.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_local.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloControler = TextEditingController();
  TextEditingController _descricaoControler = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();


  _exibirTelaCadastro({Anotacao anotacao}){

    String textoSalvarAtualizar = "";
    if(anotacao == null){

      _tituloControler.text = "";
      _descricaoControler.text = "";
      textoSalvarAtualizar = "Salvar";

    }else{

      textoSalvarAtualizar = "Atualizar";
      _tituloControler.text = anotacao.titulo;
      _descricaoControler.text = anotacao.descricao;

    }

    showDialog(
      context: context,
      builder:(context){
        return AlertDialog(
          title: Text("$textoSalvarAtualizar anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:<Widget> [
              TextField(
                controller: _tituloControler ,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Titulo",
                  hintText: "Digite o título..."
                ),
              ),
              TextField(
                controller: _descricaoControler ,
                decoration: InputDecoration(
                    labelText: "Descrição",
                    hintText: "Digite a descrição..."
                ),
              )
            ],
          ),
          actions:<Widget> [
            FlatButton(
              onPressed: ()=> Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: (){
                //_salvarAnotacao();
                _salvaAtualizarAnotacao( anotacaoSelecionada: anotacao);
                _descricaoControler.clear();
                _tituloControler.clear();
                Navigator.pop(context);
              },
              child: Text("$textoSalvarAtualizar"),
            ),
          ],
        );
      },
    );
  }
  _recuperarAnotacoes() async{
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> listaTemporaria = List<Anotacao>();

    for(var item in anotacoesRecuperadas){
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);

    }
    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = null;

    print("recuperar anotações" + anotacoesRecuperadas.toString());

  }
  _salvaAtualizarAnotacao( {Anotacao anotacaoSelecionada}) async {

    String titulo = _tituloControler.text;
    String descricao = _descricaoControler.text;

    if(anotacaoSelecionada == null){
      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);

    }else{
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _tituloControler.clear();
    _descricaoControler.clear();

    _recuperarAnotacoes();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacoes();
  }

  _formatarData(String data){
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }
  _removerAnotacao(int id) async{

    await _db.removerAnotacao(id);
    _recuperarAnotacoes();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children:<Widget> [
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              // ignore: missing_return
              itemBuilder: (context, index){
                final anotacao = _anotacoes[index];

                return Card(
                  child: ListTile(
                    title: Text(anotacao.titulo),
                    subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}") ,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:<Widget> [
                        GestureDetector(
                          onTap: (){
                            _exibirTelaCadastro(anotacao: anotacao );
                          },
                          child: Padding(padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.edit, color: Colors.green,),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _removerAnotacao(anotacao.id);
                          },
                          child: Padding(padding: EdgeInsets.only(right: 0),
                            child: Icon(Icons.remove_circle, color: Colors.red,),
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
      ) ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
        _exibirTelaCadastro();
        },
      ),
    );
  }
}
