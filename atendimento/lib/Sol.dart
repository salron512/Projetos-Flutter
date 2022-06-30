// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Sol extends StatefulWidget {
  Sol({Key? key}) : super(key: key);

  @override
  State<Sol> createState() => _SolState();
}

class _SolState extends State<Sol> {
  var _celular = MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerCelular = TextEditingController();
  final TextEditingController _controllerDescProblema = TextEditingController();

  _alertaErro(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 400,
              width: 400,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                          width: 250,
                          height: 250,
                          child: Image.asset("images/alert.png")),
                    ),
                    Text(msg)
                  ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  void _gravaSol() async {
    String nome = _controllerNome.text;
    String celular = _controllerCelular.text;
    String descProblema = _controllerDescProblema.text;
    if (nome.isNotEmpty) {
      if (celular.isNotEmpty) {
        if (descProblema.isNotEmpty) {
          FirebaseFirestore.instance.collection("solicitacao").add({
            "nome": nome,
            "telefone": _celular.unmaskText(celular),
            "descricao": descProblema
          });
        } else {
          _alertaErro('Digite a descrição do seu problema');
        }
      } else {
        _alertaErro('Digite o numero do seu celular');
      }
    } else {
      _alertaErro('Preencha o campo nome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
        borderRadius: BorderRadius.circular(32),
        elevation: 10,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(35),
            width: 850,
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
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Preencha os campos á baixo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
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
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    inputFormatters: [_celular],
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        labelText: "Digite o numero seu celular",
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
                  padding: EdgeInsets.only(top: 10),
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: ElevatedButton(
                      child: Text(
                        "Enviar",
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        _gravaSol();
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
