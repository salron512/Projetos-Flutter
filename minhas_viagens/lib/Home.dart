import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Mapas.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _adicionarLocal(){
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => Mapas()

    )
    );
  }

  _abrirMapa(){



  }
  _excluirViagem(){

  }

  List _listaViagens = [
    "Cristo Redendor",
    " Grande Muralha da China",
    "Taj Mahal",
    "Coliseu"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Viagens"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff0066cc),
        onPressed: (){
          _adicionarLocal();

        },
      ),
      body: Column(
        children: [
          Expanded(child:
          ListView.builder(
            itemCount: _listaViagens.length ,
              // ignore: missing_return
              itemBuilder: (context, index){
                String tiutlo = _listaViagens[index];
                return GestureDetector(
                  onTap: (){
                    _abrirMapa();
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(tiutlo),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: (){
                              _excluirViagem();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.remove_circle,
                              color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              )
          ),
        ],
      )

    );
  }
}
