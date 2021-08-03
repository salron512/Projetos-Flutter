

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class IndicacaoEmpresa extends StatefulWidget {
  @override
  _IndicacaoEmpresaState createState() => _IndicacaoEmpresaState();
}

class _IndicacaoEmpresaState extends State<IndicacaoEmpresa> {
  var _mascaraTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  String _msgErro = '';
  TextEditingController _controllerNomeFantasia = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();

  _salvaIdicacao() async {
    String nomeFantasia = _controllerNomeFantasia.text;
    String telefone = _controllerTelefone.text;
    String data = DateTime.now().toString();
    if (nomeFantasia.isNotEmpty) {
      if (telefone.isNotEmpty) {
        await FirebaseFirestore.instance.collection("indicacoes").doc().set({
          'nomeFantasia': nomeFantasia,
          'telefone': telefone,
          'data': data
        }).then((value) {
          setState(() {
            setState(() {
              _msgErro = "Indicação enviada com sucesso!";
            });
          });
        }).catchError((erro) {
            setState(() {
              _msgErro = "Erro ao enviar, por favor verificar sua conecção";
            });
        });
      } else {
        setState(() {
          _msgErro = "Por favor preencha o campo telefone";
        });
      }
    } else {
      setState(() {
        _msgErro = "Por favor preencha o campo nome fantasia";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Indique uma empresa"),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: Image.asset('images/negocios.png'),
                  ),
                ),
                Text(
                  "Preencha os dados para que possamos entra em contato!",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: "Nome Fantasia",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerNomeFantasia),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [_mascaraTelefone],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: "Telefone",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerTelefone),
                ),
                Text(
                  _msgErro,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Enviar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      _salvaIdicacao();
                    },
                  ),
                ),
                
              ],
            ),
          ),
        ));
  }
}
