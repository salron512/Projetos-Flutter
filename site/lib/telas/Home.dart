import 'package:flutter/material.dart';
import 'package:site/telas/Contato.dart';
import 'package:site/telas/Produtos.dart';
import 'package:site/telas/TelaInicial.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>  with SingleTickerProviderStateMixin {
  
    late TabController _tabController;

   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

   @override
  // ignore: unused_element
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
           labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          indicatorColor: Colors.white,
          controller: _tabController,
            tabs: <Widget>[
            Tab(
              text: "Home",
            ),
            Tab(
              text: "Produtos",
            ),
              Tab(
              text: "Contato",
            ),
          ],
        ),
       
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TelaInicial(),Produtos(),Contato()
        ],
      )
    );
  }
}