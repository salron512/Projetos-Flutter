// ignore_for_file: sort_child_properties_last, avoid_unnecessary_containers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RecuperarSenha extends StatefulWidget {
  RecuperarSenha({Key? key}) : super(key: key);

  @override
  State<RecuperarSenha> createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  final  TextEditingController _controllerEmail = TextEditingController();
  String _mensagenError = "";

  _recuperaSenha() async {
    String email = _controllerEmail.text;
    if (email.isNotEmpty) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((task) {
        setState(() {
          _mensagenError = "E-mail encaminhado com sucesso!";
        });
      }).catchError((error) {
        print(error);
        setState(() {
          _mensagenError = "E-mail não cadastrado";
        });
      });
    } else {
      setState(() {
        _mensagenError = "Digite o e-mail";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar senha"),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary),
        padding: const EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    "images/fpassword.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Center(
                        child: Text(
                      _mensagenError,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ))),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerEmail,
                  ),
                ),
                ElevatedButton(
                  child: const Text(
                    "Recuperar senha",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffFF0000),
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    _recuperaSenha();
                  },
                ),
              ]),
        )),
      ),
    );
  }
}
