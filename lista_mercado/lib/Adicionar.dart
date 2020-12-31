import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Adicionar extends StatefulWidget {
  @override
  _AdicionarState createState() => _AdicionarState();
}

class _AdicionarState extends State<Adicionar> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController _controllerAdicionar = TextEditingController();
  String _mensagemErro = "";
  String _usuarioAdcionado ;
  Map _dados = Map();

  _pesquisaUsuario()async {
    String usuarioselecionado = _controllerAdicionar.text;
    _usuarioAdcionado = usuarioselecionado;
    QuerySnapshot querySnapshot = await db.collection("usuarios").where(
        "email", isEqualTo: usuarioselecionado).get();

    for (DocumentSnapshot item in querySnapshot.docs) {

      var dados = item.data();
      _dados ={
        "nome" : dados["nome"],
        "email" : dados["email"]
      };

    }
      //fazer a parte de mensagem para o usuairo
    if(_dados.values.isEmpty){
      print("vazio");
    }else{

      print("ok");
    }
    _dados.clear();
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
                Padding(padding: EdgeInsets.all(20),
                  child: Text(_mensagemErro,
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: 10
                  ),) ,
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
