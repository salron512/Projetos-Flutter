import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecuperaSenha extends StatefulWidget {
  @override
  _RecuperaSenhaState createState() => _RecuperaSenhaState();
}

class _RecuperaSenhaState extends State<RecuperaSenha> {
  TextEditingController _controllerEmail = TextEditingController();
  String _mensagenError = "";

  _recuperaSenha() async {
    String email = _controllerEmail.text;
    if (email.isNotEmpty) {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.sendPasswordResetEmail(email: email).then((task) {
        setState(() {
          _mensagenError = "E-mail encaminhado com sucesso!";
        });
      }).catchError((error) {
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
        title: Text("Recuperar senha"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffDCDCDC)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      "images/reset.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Center(
                          child: Text(
                        _mensagenError,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ))),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerEmail,
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      "Recuperar senha",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff37474f),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                    onPressed: () {
                      _recuperaSenha();
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
