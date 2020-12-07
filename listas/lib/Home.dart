import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _itens = [];

  void _carregarItens(){

    _itens = [];
  for(int i=1; i<=10; i++){
    
   Map<String, dynamic> item = Map();
   item["titulo"] = "Titulo $i teste de lista";
   item["descricao"] = "Descrição $i teste de lista";
   _itens.add(item);
  }
  }
  @override
  Widget build(BuildContext context) {
    _carregarItens();
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _itens.length,
          itemBuilder: (context, indicie){
            return ListTile(
              onTap: (){
                showDialog(
                    context: context,
                  builder: (context){
                      return AlertDialog(
                        title: Text(_itens[indicie]["titulo"]),
                        titlePadding: EdgeInsets.all(20),
                        titleTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.orange
                        ),
                        content: Text(_itens[indicie]["descricao"]),
                        //backgroundColor: Colors.red,
                        actions:<Widget> [
                          FlatButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("Sim")),
                          FlatButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("Não"))
                        ],
                      );
                  }
                );
              },
              //onLongPress: (){},
            title: Text(_itens[indicie]["titulo"]),
              subtitle: Text(_itens[indicie]["descricao"]),
            );
          },
        ),
      ),
    );
  }
}
