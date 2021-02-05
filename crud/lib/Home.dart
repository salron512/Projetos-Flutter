import 'package:crud/Cliente.dart';
import 'package:crud/Produtos.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Widget> _listatelas = [
    Produtos(),
    Cliente()
  ];
  int index = 0;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("CRUD"),
      ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
                  child: Column(
                    children:<Widget> [
                      Text("Titulo"),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
              ListTile(
                leading: Icon(Icons.local_grocery_store),
                title: Text("Produtos"),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => SegundaTela()));
                  setState(() {
                    index = 0;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.people_alt),
                title: Text('Clientes'),
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
      padding: EdgeInsets.all(5),
      child: _listatelas[index] ,
    ),
    );


  }
}
