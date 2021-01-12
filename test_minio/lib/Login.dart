import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_minio/Lista.dart';

import 'Home.dart';
import 'Usuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o e-mail!";
      });
    }
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Lista()));
    }).catchError((error) {
      setState(() {
        _mensagemErro =
            "Erro ao autenticar o usuário, verifique e-mail e senha e tente novamente!";
      });
    });

    setState(() {
      _controllerSenha.text = "";
    });
  }

  Future _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    var usuariologado = await auth.currentUser;

    if (usuariologado != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Lista()));
    }
  }

  @override
  void initState() {
    _verificaUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blue),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                    controller: _controllerSenha,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _validarCampos();
                      },
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                        child: Text(
                          "Não Tem conta? cadastre-se!",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {}),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Center(
                          child: Text(
                        _mensagemErro,
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
