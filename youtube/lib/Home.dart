import 'package:flutter/material.dart';
import 'package:youtube/telas/Biblioteca.dart';
import 'package:youtube/telas/EmAlta.dart';
import 'package:youtube/telas/Inicio.dart';
import 'package:youtube/telas/Inscricoes.dart';
import 'CustomSearchDelegate.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _indiceAtual = 0;
  String resultado = "";
  @override
  Widget build(BuildContext context) {



    List<Widget> telas = [
     Inicio(resultado),
      EmAlta(),
      Inscricoes(),
      Biblioteca(),
    ];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey,
          opacity: 1,
        ),
        title: Image.asset("images/youtube.png", width: 98, height: 22,),
        actions:<Widget> [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async{
             String res = await  showSearch(context: context, delegate: CustomSearchDelegate());
             setState(() {
               resultado = res;
             });
            },
          ),


          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: (){},
          ),

          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: (){},
          )

        ],
        backgroundColor: Colors.white,
      ),
      body:Container(
        padding: EdgeInsets.all(16),
        child: telas[_indiceAtual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual ,
        onTap:(indice){
          setState(() {
            _indiceAtual = indice;
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
              // ignore: deprecated_member_use
              title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            // ignore: deprecated_member_use
            title: Text("Em alta"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            // ignore: deprecated_member_use
            title: Text("Inscrições"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            // ignore: deprecated_member_use
            title: Text("Biblioteca"),
          ),
        ],
      ),
    );
  }
}
