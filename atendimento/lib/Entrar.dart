import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Entrar extends StatefulWidget {
  Entrar({Key? key}) : super(key: key);

  @override
  State<Entrar> createState() => _EntrarState();
}

class _EntrarState extends State<Entrar> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  bool _motrarSenha = false;
  String _msg = '';

  _verificaCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty) {
      if (senha.isNotEmpty) {
        _Login();
      } else {
        setState(() {
          _msg = "Preencha o campo senha";
        });
      }
    } else {
      setState(() {
        _msg = "Preencha o campo email";
      });
    }
  }

  _Login() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((value) {
      //colocar aqui se o login der certo
    }).catchError((e) {
      setState(() {
        _msg = "Por favor verifique o email e senha";
      });
    });
  }

  _veririficaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures
    var usuario = await auth.currentUser;
    if (usuario != null) {
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _veririficaUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 32, bottom: 15),
                      child: Container(
                        width: 250,
                        height: 250,
                        child: Image.asset("images/logomarca.png"),
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
                        onPressed: () {
                          Navigator.pushNamed(context, "/reset");
                        },
                        child: Text(
                          "Recuperar senha",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))
                  ],
                ),
              )),
        ),
      ),
    ));
  }
}
