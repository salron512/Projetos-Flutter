import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SugestaoUsuario extends StatefulWidget {
  String categorias;
  SugestaoUsuario(this.categorias);
  @override
  _SugestaoUsuarioState createState() => _SugestaoUsuarioState();
}

class _SugestaoUsuarioState extends State<SugestaoUsuario> {
  var _mascaraTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerWhatsapp = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    String nome = _controllerNome.text;
    String telefone = _controllerTelefone.text;
    String whatsapp = _controllerWhatsapp.text;
    String categoria = widget.categorias;
    if (nome.isNotEmpty) {
      if (telefone.isNotEmpty) {
        if (whatsapp.isNotEmpty) {
          _salvaSugestao(nome, telefone, whatsapp, categoria);
        } else {
          setState(() {
            _mensagemErro = "Preencha o campo whatsapp";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha o campo telefone";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o campo nome";
      });
    }
  }

  _salvaSugestao(
      String nome, String telefone, String whatsapp, String categoria) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("sugestao").doc().set({
      "nome": nome,
      "telefone": telefone,
      "whatsapp": whatsapp,
      "categoria": categoria,
    }).then((value) {
      setState(() {
        _mensagemErro = "Sugestão enviado com sucesso!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sugestão"),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "images/user.png",
                width: 200,
                height: 150,
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Center(
                      child: Text(
                    _mensagemErro,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ))),
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
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                  controller: _controllerNome,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_mascaraTelefone],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Telefone",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          setState(() {
                            _controllerTelefone.clear();
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                  controller: _controllerTelefone,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_mascaraTelefone],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Whatsapp",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          setState(() {
                            _controllerWhatsapp.clear();
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                  controller: _controllerWhatsapp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 10),
                child: RaisedButton(
                  child: Text(
                    "Enviar sugestão",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    _validarCampos();
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
