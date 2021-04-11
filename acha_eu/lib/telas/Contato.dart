import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//tela de contado do profissional do adm
class Contato extends StatefulWidget {
  @override
  _ContatoState createState() => _ContatoState();
}

class _ContatoState extends State<Contato> {
  _abrirWhatsApp() async {
    String telefone = "66992040567";
    var whatsappUrl = "whatsapp://send?phone=+55$telefone=Olá,tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  _abrirTelefone() async {
    String telefone = "66992040567";
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
          title: Text("Contato"),
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xffDCDCDC)),
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Image.asset("images/business.png",
                      width: 200, height: 150),
                ),
                Text(
                  "Faça seu anuncio no nosso app entre em contato nas opções abaixo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16, top: 16),
                  child: ElevatedButton(
                    child: Text(
                      "Whatasapp",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                    onPressed: () {
                      _abrirWhatsApp();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    child: Text(
                      "Telefone",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff37474f),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                    onPressed: () {
                      _abrirTelefone();
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
