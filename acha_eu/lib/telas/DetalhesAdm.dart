import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//datalhes do usuario
// ignore: must_be_immutable
class DetalhesAdm extends StatefulWidget {
  Usuario usuario;

  DetalhesAdm(this.usuario);

  @override
  _DetalhesAdmState createState() => _DetalhesAdmState();
}

class _DetalhesAdmState extends State<DetalhesAdm> {
  _abrirWhatsApp() async {
    String telefone = widget.usuario.whatsapp;
    var whatsappUrl = "whatsapp://send?phone=+55$telefone=Olá,tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  _abrirTelefone() async {
    String telefone = widget.usuario.telefone;
    var telefoneUrl = "tel:$telefone";

    if (await canLaunch(telefoneUrl)) {
      await launch(telefoneUrl);
    } else {
      throw 'Could not launch $telefoneUrl';
    }
  }

  _AtualizadDados() async{
    //habilita o campo mostraPagamento do usuario
    // caso widget.usuario.mostraPagamento seja true
    FirebaseFirestore db =  FirebaseFirestore.instance;
    if(widget.usuario.mostraPagamento){
      await db.collection("usuarios").doc(widget.usuario.idUsuario).update({
        "mostraPagamento": widget.usuario.mostraPagamento,
      });
       //habilita o campo mostraPagamento do usuario
       // caso widget.usuario.mostraPagamento seja false
    }else{
      await db.collection("usuarios").doc(widget.usuario.idUsuario).update({
        "mostraPagamento": widget.usuario.mostraPagamento,
        "categoria": "Cliente",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes usuario"),
      ) ,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 36,left: 32,right: 16,bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "images/gear.png",
                width: 200,
                height: 150,
              ),
              Padding(padding: EdgeInsets.only(top: 16),
                child: Text("Nome: " + widget.usuario.nome,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10),
                child: Text("Telefone: " + widget.usuario.telefone,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10),
                child: Text("ID Usuario: " + widget.usuario.idUsuario,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10),
                child: Text("E-mail: " + widget.usuario.email,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10),
                child: Text("Categoria: " + widget.usuario.categoriaUsuario,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10),
                child: Text("Cidade: " + widget.usuario.cidade,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10),
                child: Text("Estado: " + widget.usuario.estado,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                  child: Row(
                    children: [
                      Checkbox(
                        value: widget.usuario.mostraPagamento,
                        onChanged: (value){
                          setState(() {
                            widget.usuario.mostraPagamento = value;
                          });
                          _AtualizadDados();
                        },
                      ),
                      Text("Anunciante")
                    ],
                  )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16, top: 16),
                child: RaisedButton(
                  child: Text(
                    "Whatasapp",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    _abrirWhatsApp();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: RaisedButton(
                  child: Text(
                    "Telefone",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color:Color(0xff37474f),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    _abrirTelefone();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
