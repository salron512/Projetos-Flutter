import 'package:drawer/SegundaTela.dart';
import 'package:drawer/TerceiraTela.dart';
import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List<Widget> _listatelas = [
    SegundaTela(),
    TerceiraTela()
  ];

  String imagem = "images/padrao.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
               child: Column(
                children:<Widget> [
                  Image.asset(imagem, width: 100, height: 100,),
                  Text("Titulo"),
          ],
        ),
        ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.ac_unit),
              title: Text("Primeira tela"),
              onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => SegundaTela()));
              setState(() {
                index = 0;
                Navigator.pop(context);
              });
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Segunda Tela'),
              onTap: () {
               setState(() {
                 index = 1;
               });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _listatelas[index] ,
      ),
    );
  }
}

