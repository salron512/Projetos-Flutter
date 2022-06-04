import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text("Titulo"),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
          ),
          // ignore: prefer_const_constructors
          ListTile(
            leading: Icon(Icons.history_toggle_off),
            title: const Text("Meus atendimento"),
          ),
           // ignore: prefer_const_constructors
           ListTile(
             leading: const Icon(Icons.history_edu),
            title: const Text("Histórico de atendimento"),
          )
        ]),
      ),
    );
  }
}
