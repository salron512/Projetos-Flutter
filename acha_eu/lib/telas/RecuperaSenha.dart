import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecuperaSenha extends StatefulWidget {
  @override
  _RecuperaSenhaState createState() => _RecuperaSenhaState();
}

class _RecuperaSenhaState extends State<RecuperaSenha> {

  TextEditingController _controllerEmail = TextEditingController();
  String _mensagenError = "";

  _recuperaSenha() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    String email = _controllerEmail.text;
    User usuario = await auth.currentUser;
    if(usuario != null){
      auth.sendPasswordResetEmail(email: email).then((task){
        setState(() {
          _mensagenError = "E-mail encaminhado com sucesso!";
        });
      }).catchError((error){
        setState(() {
          _mensagenError = "Falha ao recupera usuario";
        });
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
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
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                      child: Text(
                        "Recuperar senha",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.green,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _recuperaSenha();
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Center(
                          child: Text(
                            _mensagenError,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          )))
                ]),
          ),
        ),
      ),
    );
  }
}
