import 'package:acha_eu/model/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesContado extends StatefulWidget {
  Usuario usuario;
  DetalhesContado(this.usuario);

  @override
  _DetalhesContadoState createState() => _DetalhesContadoState();
}


class _DetalhesContadoState extends State<DetalhesContado> {


  _abrirWhatsApp() async {

    String telefone = widget.usuario.telefone;
    var whatsappUrl = "whatsapp://send?phone=+55$telefone=Olá,tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
  _abrirTelefone() async {

    String telefone = widget.usuario.telefone;
    var whatsappUrl = "tel:$telefone";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario.nome),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
             CircleAvatar(
                backgroundImage: widget.usuario.urlImagem != null
                    ? NetworkImage(widget.usuario.urlImagem)
                    : null,
                maxRadius: 100,
                backgroundColor: Colors.grey),
            Padding(
              padding: EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                "Contato",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
             Padding(
              padding: EdgeInsets.only(bottom: 8),
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
              padding: EdgeInsets.only(bottom: 8),
              child: RaisedButton(
                child: Text(
                  "Telefone",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.green,
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                onPressed: () {
                  _abrirTelefone();
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
