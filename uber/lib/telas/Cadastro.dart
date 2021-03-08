import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber/Model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}



class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  bool _tipoUsuario = false;
  String _mensagemError = "";

  _validarCampos() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isNotEmpty) {
      if(email.isNotEmpty && email.contains("@")){
        if(senha.isNotEmpty && senha.length > 6){

          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;
          usuario.tipoUsuario = usuario.verificaTipoUsuario(_tipoUsuario);
          _cadastraUsuario(usuario);

        }else{
          setState(() {
            _mensagemError = "Senha inválido";
          });
        }
      }else{
       setState(() {
         _mensagemError = "E-mail inválido";
       });
      }
    } else {
     setState(() {
       _mensagemError = "Nome inválido";
     });
    }
  }
  _cadastraUsuario( Usuario usuario ){

    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db =  Firestore.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha ).then((firebaseUser){
          db.collection("usuarios").document(firebaseUser.user.uid).setData(
            usuario.toMap());
          switch(usuario.tipoUsuario){
            case "motorista":
              Navigator.pushNamedAndRemoveUntil(context, "/PainelMotorista", (route) => false);
              break;
            case "passageiro":
              Navigator.pushNamedAndRemoveUntil(context, "/PainelPassageiro", (route) => false);
              break;
          }
    }).catchError((error){
      setState(() {
        _mensagemError = "Usuario inválido";
      });
    })
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 8, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    controller: _controllerNome,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Digite seu nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.emailAddress,
                    controller: _controllerEmail,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Digite seu e-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
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
                Row(
                  children: [
                    Text("Passageiro"),
                    Switch(
                        value: _tipoUsuario,
                        onChanged: (bool valor) {
                          setState(() {
                            _tipoUsuario = valor;
                          });
                        }),
                    Text("Motorista"),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
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
                  child: Text(
                    _mensagemError,
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
