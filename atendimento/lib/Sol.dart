// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Sol extends StatefulWidget {
  Sol({Key? key}) : super(key: key);

  @override
  State<Sol> createState() => _SolState();
}

class _SolState extends State<Sol> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();
  TextEditingController _controllerDescProblema = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
        borderRadius: BorderRadius.circular(32),
        elevation: 10,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(35),
            width: 800,
            height: 550,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                        width: 100,
                        height: 100,
                        child: Image.asset("images/problema.png"))),
                        Padding(padding: const EdgeInsets.only(top: 8),
                        child:  Text("Preencha os campos á baixo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                        ),
                        ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        labelText: "Digite seu nome",
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 25, 16, 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    controller: _controllerNome,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        labelText: "Digite seu celular",
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 25, 16, 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    controller: _controllerCelular,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    maxLines: 5,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        labelText: "Descrição do problema",
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 25, 16, 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    controller: _controllerDescProblema,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
