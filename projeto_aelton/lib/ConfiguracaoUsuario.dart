import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_aelton/model/Usuario.dart';

class ConfiguracaoUsuario extends StatefulWidget {
  @override
  _ConfiguracaoUsuarioState createState() => _ConfiguracaoUsuarioState();
}

class _ConfiguracaoUsuarioState extends State<ConfiguracaoUsuario> {
  var _mascaraTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  Usuario _usuario = Usuario();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllertelefone = TextEditingController();
  TextEditingController _controllerwhatsapp = TextEditingController();
  TextEditingController _controllerendereco = TextEditingController();
  TextEditingController _controllerbairro = TextEditingController();
  TextEditingController _controllercidade = TextEditingController();
  TextEditingController _controllerPontoReferencia = TextEditingController();
  String _mensagemErro = "";

  Future _recuperaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String id = auth.currentUser.uid;
    var dados = await db.collection("usuarios").doc(id).get();
    Map<String, dynamic> map = dados.data();

    setState(() {
      _controllerNome.text = map["nome"];
      _controllertelefone.text = map["telefone"];
      _controllertelefone.text = map["telefone"];
      _controllerwhatsapp.text = map["whatsapp"];
      _controllerendereco.text = map["endereco"];
      _controllerbairro.text = map["bairro"];
      _controllercidade.text = map["cidade"];
      _controllerPontoReferencia.text = map["pontoReferencia"];
      _usuario = _usuario;
    });
  }

  _atualizaDados() {
    if (_controllerNome.text.isNotEmpty) {
      if (_controllertelefone.text.isNotEmpty) {
        if (_controllerendereco.text.isNotEmpty) {
          if (_controllerbairro.text.isNotEmpty) {
            if (_controllerPontoReferencia.text.isNotEmpty) {
              if (_controllercidade.text.isNotEmpty) {
                if (_controllerwhatsapp.text.isNotEmpty) {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  FirebaseAuth auth = FirebaseAuth.instance;
                  String id = auth.currentUser.uid;
                  db.collection("usuarios").doc(id).update({
                    "nome": _controllerNome.text,
                    "telefone": _controllertelefone.text,
                    "whatsapp": _controllerwhatsapp.text,
                    "endereco": _controllerendereco.text,
                    "bairro": _controllerbairro.text,
                    "cidade": _controllercidade.text,
                    "pontoReferencia": _controllerPontoReferencia.text,
                  });
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/carrinho", (route) => false);
                } else {
                  setState(() {
                    _mensagemErro = "Preencha o campo whatsapp";
                  });
                }
              } else {
                setState(() {
                  _mensagemErro = "Preencha o campo cidade";
                });
              }
            } else {
              setState(() {
                _mensagemErro = "Preencha o campo ponto de referência";
              });
            }
          } else {
            setState(() {
              _mensagemErro = "Preencha o campo bairro";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Preencha o campo endereço";
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

  @override
  void initState() {
    super.initState();
    _recuperaUsuario();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
        ),
        body: _usuario == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              labelText: "Nome completo",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: _controllerNome,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TextField(
                          autofocus: false,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [_mascaraTelefone],
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controllertelefone.clear();
                                  });
                                },
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              labelText: "Telefone",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: _controllertelefone,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TextField(
                          autofocus: false,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [_mascaraTelefone],
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controllerwhatsapp.clear();
                                  });
                                },
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              labelText: "Whatsapp",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: _controllerwhatsapp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              labelText: "Endereço",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: _controllerendereco,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              labelText: "Bairro",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: _controllerbairro,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              labelText: "Ponto de referência",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: _controllerPontoReferencia,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              labelText: "Cidade",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: _controllercidade,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          child: Text(
                            "Atualizar",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: Color(0xffFF0000),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          onPressed: () {
                            _atualizaDados();
                          },
                        ),
                      ),
                      Center(
                          child: Text(
                        _mensagemErro,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ))
                    ],
                  ),
                ),
              ));
  }
}
