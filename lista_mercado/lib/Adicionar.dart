import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_mercado/Home.dart';

class Adicionar extends StatefulWidget {
  @override
  _AdicionarState createState() => _AdicionarState();
}

class _AdicionarState extends State<Adicionar> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController _controllerAdicionar = TextEditingController();
  String _mensagemErro = "";
  String _usuarioAdcionado;
  String _idUsuarioLogado;
  String _UsuarioLogadoNome;
  Map _dados = Map();
  var _idusuario;

  _pesquisaUsuario() async {
    String usuarioselecionado = _controllerAdicionar.text;
    _usuarioAdcionado = usuarioselecionado;
    QuerySnapshot querySnapshot = await db
        .collection("usuarios")
        .where("email", isEqualTo: usuarioselecionado)
        .get();

    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data();
      _idusuario = item.id;
      _dados = {"nome": dados["nome"], "email": dados["email"]};
    }
    //fazer a parte de mensagem para o usuairo
    if (_dados.values.isEmpty) {
      print("vazio");

      setState(() {
        _mensagemErro = "Usuario não encontrado!";
      });
    } else {
      print("ok " + _idusuario);
      setState(() {
        _mensagemErro = "Convite enviado!";
      });
      _salvaConvite();
    }
    _dados.clear();
  }

  _salvaConvite() async {

    if (_idUsuarioLogado == _idusuario) {
      setState(() {
        _mensagemErro = "Você está tentando adicionar você mesmo";
      });
    } else {
      db
          .collection("convites")
          .doc(_idusuario)
          .collection(_idUsuarioLogado)
          .doc(_idUsuarioLogado)
          .set({
                  "idRemetente": _idUsuarioLogado,
                  "idDestinatario": _idusuario,
                  "estado": true,
                  "NomeRemetente": _UsuarioLogadoNome,
      });
    }
  }

  _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuariologado = await auth.currentUser;
    _idUsuarioLogado = usuariologado.uid;
    print("ID usuario " + _idUsuarioLogado);

    var dados = await db.collection("usuarios").doc(_idUsuarioLogado).get();

    var itemRecuperado = dados.data();
    _UsuarioLogadoNome = itemRecuperado["nome"];
    print(itemRecuperado["nome"]);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificaUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Adicionar membros"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Digite o email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                  controller: _controllerAdicionar,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Enviar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.purple,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _pesquisaUsuario();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
