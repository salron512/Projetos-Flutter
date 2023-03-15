// ignore_for_file: file_names

import 'package:email/telas/config.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  int _i = 0;

  List<Widget> _listaMenu = const [Home(), Config()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (value) {
              setState(() {
                _i = value;
                _listaMenu[_i];
              });
            },
            minWidth: 10,
            selectedIndex: _i,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home),
                  selectedIcon: Icon(Icons.home),
                  label: Text("Home")),
              NavigationRailDestination(
                  icon: Icon(Icons.devices),
                  selectedIcon: Icon(Icons.devices),
                  label: Text("Config")),
            ],
          ),
          Expanded(
              child: Container(
            child: _listaMenu[_i],
          ))
        ],
      ),
    );
  }
}
