import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  // ignore: prefer_final_fields

  bool _motrarSenha = false;
  String _msg = "";

  // ignore: non_constant_identifier_names
  _Login() async {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    if (email.isNotEmpty) {
      if (senha.isNotEmpty) {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: senha)
              .then((value) {
            setState(() {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            });
          });
        } on FirebaseException catch (erro) {
          setState(() {
         
            // ignore: avoid_print
            print(erro.toString());
            _msg = "Erro ao autenticar o usuário, verifique e-mail e"
                " senha e tente novamente!";
          });
        }
      } else {
        setState(() {
          _msg = "Preencha o campo senha";
        });
      }
    } else {
      setState(() {
        _msg = "Preencha o campo e-mail";
      });
    }
  }

  _veririficaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures
    var usuario = await auth.currentUser;
    if (usuario != null) {
      // ignore: use_build_context_synchronously
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 15),
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Image.asset("images/logo_inicial.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _msg,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  controller: _controllerEmail,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  obscureText: !_motrarSenha,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: (() {
                            setState(() {
                              _motrarSenha = !_motrarSenha;
                            });
                          }),
                          icon: _motrarSenha
                              ? const Icon(
                                  Icons.visibility,
                                )
                              : const Icon(Icons.visibility_off)),
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  controller: _controllerSenha,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    _Login();
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff37474f),
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/recuperaSenha');
                  },
                  child: const Text(
                    "Recuperar senha",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}