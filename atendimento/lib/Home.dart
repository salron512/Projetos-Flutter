// ignore_for_file: sort_child_properties_last

import 'package:atendimento/Sol.dart';
import 'package:atendimento/model/Clientes.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Clientes cliente;
  Home(this.cliente);
//Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _i = 0;
  List<Widget> _listatelas = [
    Sol(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Image.asset('images/companhia.png'),
                  ),
                  Text(
                    widget.cliente.nomeFantasia,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          // ignore: prefer_const_constructors
          ListTile(
            leading: const Icon(Icons.history_toggle_off),
            title: const Text("Meus atendimento"),
          ),
          // ignore: prefer_const_constructors
          ListTile(
            leading: const Icon(Icons.history_edu),
            title: const Text("Histórico de atendimento"),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sair"),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
          ),
        ]),
      ),
      body:  Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          alignment: Alignment.center,
          child: _listatelas[_i],
        ),

    );
  }
}
