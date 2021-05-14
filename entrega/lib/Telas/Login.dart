import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  bool _motrarSenha = false;
  String _msg = "";

  _verificaCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    if (email.isNotEmpty) {
      if (senha.isNotEmpty) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: senha)
            .then((value) {
          setState(() {
            _msg = "Entrando...";
          });
          _controllerSenha.clear();
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        }).catchError((erro) {
          setState(() {
            _msg = "Erro ao autenticar o usuário, verifique e-mail e"
                " senha e tente novamente!";
          });
        });
      } else {
        setState(() {
          _msg = "Por favor preencha o campo senha";
        });
      }
    } else {
      setState(() {
        _msg = "Por favor preencha o campo e-mail";
      });
    }
  }

  _veririficaUsuario() {
    User usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
   // _veririficaUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Theme.of(context).accentColor),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 15),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: Image.asset("images/food-delivery.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    _msg,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerEmail,
                  ),
                ),
                TextField(
                  obscureText: !_motrarSenha,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      //prefix:Icon(Icons.security),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: _motrarSenha ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _motrarSenha = !_motrarSenha;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  controller: _controllerSenha,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      _verificaCampos();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff37474f),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/cadastro");
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Recuperar senha",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
