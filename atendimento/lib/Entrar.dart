// ignore_for_file: use_build_context_synchronously

import 'package:atendimento/Home.dart';
import 'package:atendimento/model/Clientes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Entrar extends StatefulWidget {
  Entrar({Key? key}) : super(key: key);

  @override
  State<Entrar> createState() => _EntrarState();
}

class _EntrarState extends State<Entrar> {
  Clientes _cliente = new Clientes();
  // ignore: prefer_final_fields
  TextEditingController _controllerCnpj = TextEditingController(text: '00.000.000/0001-11');
  // ignore: prefer_final_fields
  var _mascaraCnpj = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});
  String _msg = 'Digite o Cnpj da empressa ';

  _verificaCampos() {
    String cnpj = _controllerCnpj.text;
    if (cnpj.isNotEmpty) {
      _Login();
    } else {
      setState(() {
        _msg = 'Digite o Cnpj';
      });
    }
  }

  // ignore: non_constant_identifier_names
  _Login() async {
    String cnpj = _controllerCnpj.text;
    String confirmacaoCnpj = '';
    FirebaseFirestore db = FirebaseFirestore.instance;
    var snapshot =
        await db.collection("clientes").where("cnpj", isEqualTo: cnpj).get();

    if (snapshot.docs.isNotEmpty) {
      for (var item in snapshot.docs) {
        var dados = item.data();
        Map<String, dynamic> result = dados;
        String confirmacaoCnpj = result["cnpj"];

        _cliente.Cnpj = result["cnpj"];
        _cliente.bairro = result["bairro"];
        _cliente.razaoSocial = result["razaoSocial"];
        _cliente.nomeFantasia = result["nomeFantasia"];
        _cliente.telefone = result["telefone"];
        _cliente.endereco = result["endereco"];

        if (_cliente.Cnpj == cnpj) {
          FirebaseAuth.instance.signInAnonymously();

          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false,
              arguments: _cliente);

          //Navigator.pushReplacementNamed(context, '/home', arguments: _cliente);
        } else {
          setState(() {
            _msg = 'Cnpj não encontrado';
          });
        }
      }
    } else {
      setState(() {
        _msg = "Cnpj não entrado";
      });
    }
  }

/*
  _veririficaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures
    var usuario = await auth.currentUser;
    if (usuario != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    }
  }
*/
  @override
  void initState() {
    super.initState();
    // _veririficaUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Container(
                  child: Column(
                children: [
                  Container(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 15),
                          child: Container(
                            width: 250,
                            height: 250,
                            child: Image.asset("images/logomarca.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _msg,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TextField(
                            inputFormatters: [_mascaraCnpj],
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(32, 16, 32, 16),
                                hintText: "CNPJ",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            controller: _controllerCnpj,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 10),
                          child: ElevatedButton(
                            child: const Text(
                              "Entrar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              padding:
                                  const EdgeInsets.fromLTRB(32, 16, 32, 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {
                              _verificaCampos();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            child: const Text(
                              "Área reservada",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff37474f),
                              padding:
                                  const EdgeInsets.fromLTRB(32, 16, 32, 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))),
        ),
      ),
    ));
  }
}
