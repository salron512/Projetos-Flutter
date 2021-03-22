import 'package:acha_eu/model/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesSugestao extends StatefulWidget {
  Usuario usuario;
  DetalhesSugestao(this.usuario);

  @override
  _DetalhesSugestaoState createState() => _DetalhesSugestaoState();
}

class _DetalhesSugestaoState extends State<DetalhesSugestao> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes"),
      ),
      body:  Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 36,left: 32,right: 16,bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "images/sugestao.png",
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
                child: Text("Whatsapp " + widget.usuario.whatsapp,
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
