import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber/Model/Usuario.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemError = "";
  bool _carregando = false;

  _logarUsuario(Usuario usuario) async {
    setState(() {
      _carregando = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((user) {
      _redirecionaPainelPorTipoUsuario(user.user.uid);
    }).catchError((error) {
      _mensagemError = "Error ao autenticar verifique email ou sennha!";
    });
  }

  _redirecionaPainelPorTipoUsuario(String idUsuario) async {
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(idUsuario).get();
    Map<String, dynamic> dados = snapshot.data;
    String tipoUsuario = dados["tipoUsuario"];
    setState(() {
      _carregando = false;
    });

    switch (tipoUsuario) {
      case "motorista":
        Navigator.pushReplacementNamed(context, "/PainelMotorista");
        print("painel motorista");
        break;
      case "passageiro":
        Navigator.pushReplacementNamed(context, "/PainelPassageiro");
        print("painel passageiro");
        break;
    }
  }

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        Usuario usuario = Usuario();
        //usuario.nome = nome;
        usuario.email = email;
        usuario.senha = senha;
        //usuario.tipoUsuario = usuario.verificaTipoUsuario(_tipoUsuario);
        // _cadastraUsuario(usuario);
        _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemError = "Senha inválido";
        });
      }
    } else {
      setState(() {
        _mensagemError = "E-mail inválido";
      });
    }
  }

  _veirificaUsuarioLogado() async {
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    var usuario = await auth.currentUser();
    if (usuario != null) {
      DocumentSnapshot snapshot =
          await db.collection("usuarios").document(usuario.uid).get();
      Map<String, dynamic> dados = snapshot.data;
      String tipoUsuario = dados["tipoUsuario"];
      switch (tipoUsuario) {
        case "motorista":
          Navigator.pushReplacementNamed(context, "/PainelMotorista");
          print("painel motorista");
          break;
        case "passageiro":
          Navigator.pushReplacementNamed(context, "/PainelPassageiro");
          print("painel passageiro");
          break;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _veirificaUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imagens/fundo.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Digite seu e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _controllerSenha,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Digite sua senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    color: Color(0xff1ebbd8),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    onPressed: () {
                      _validarCampos();
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Ainda não tem conta? Cadastre-se!",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/Cadastro");
                    },
                  ),
                ),
                _carregando
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Center(
                    child: Text(
                      _mensagemError,
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
