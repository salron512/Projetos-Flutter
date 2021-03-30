import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_aelton/model/Usuario.dart';

class ConfiguracaoUsuario extends StatefulWidget {
  @override
  _ConfiguracaoUsuarioState createState() => _ConfiguracaoUsuarioState();
}

class _ConfiguracaoUsuarioState extends State<ConfiguracaoUsuario> {
  Usuario _usuario = Usuario();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllertelefone = TextEditingController();
  TextEditingController _controllerwhatsapp = TextEditingController();
  TextEditingController _controllerendereco = TextEditingController();
  TextEditingController _controllerbairro = TextEditingController();
  TextEditingController _controllercidade = TextEditingController();


  Future _recuperaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String id = auth.currentUser.uid;
    var dados = await db.collection("usuarios").doc(id).get();
    Map<String, dynamic> map = dados.data();
    Usuario usuario = Usuario();


   setState(() {
     _controllerNome.text = map["nome"];
     _controllertelefone.text = map["telefone"];
     _usuario = _usuario;
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: _usuario == null ?
          Center(
            child: CircularProgressIndicator(),
          )
          :
          Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      "images/usericon.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Nome completo",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerNome,
                    ),
                  ),

                ],
              ),

            ),
          )
    );
  }
}
