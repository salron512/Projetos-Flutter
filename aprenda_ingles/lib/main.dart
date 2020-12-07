import 'package:aprenda_ingles/Bichos.dart';
import 'package:aprenda_ingles/Numeros.dart';
import 'package:aprenda_ingles/Vogais.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xff795548),
      //accentColor: Colors.white,
      //primaryColorDark: Colors.brown,
      scaffoldBackgroundColor: Color(0xfff5e9b9),
    ),
    debugShowCheckedModeBanner: false,
    home: Home() ,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: 0
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.brown,
        title: Text("Aprenda Inglês"),
        bottom: TabBar(
          indicatorWeight: 4,
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          controller: _tabController,
          tabs:<Widget> [
            Tab(
              text: "Bichos",
            ),
            Tab(
              text: "Números",
            ),
            Tab(
              text: "Vogais",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:<Widget> [
          Bichos(),
          Numeros(),
         Vogais(),
        ],
      ),
    );
  }
}
