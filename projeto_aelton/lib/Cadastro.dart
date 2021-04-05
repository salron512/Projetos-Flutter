import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'model/Usuario.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  var _mascaraTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmaSenha = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerCidade = TextEditingController();
  TextEditingController _controllerWhatsapp = TextEditingController();
  TextEditingController _controllerPontoReferencia = TextEditingController();
  String _mensagemErro = "";
  bool _motrarSenha = false;
  bool _motrarSenhaConfirma = false;
  _validarCampos() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String confirmaSenha = _controllerConfirmaSenha.text;
    String telefone = _controllerTelefone.text;
    String endereco = _controllerEndereco.text;
    String bairro = _controllerBairro.text;
    String cidade = _controllerCidade.text;
    String whatsapp = _controllerWhatsapp.text;
    String pontoReferencia = _controllerPontoReferencia.text;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty) {
        if (email.contains("@")) {
          if (senha.isNotEmpty) {
            if (senha == confirmaSenha) {
              if (senha.length > 6) {
                if (telefone.isNotEmpty) {
                  if (endereco.isNotEmpty) {
                    if (bairro.isNotEmpty) {
                      if (cidade.isNotEmpty) {
                        if (whatsapp.isNotEmpty) {
                          if (pontoReferencia.isNotEmpty) {
                            Usuario usuario = Usuario();
                            usuario.nome = nome;
                            usuario.email = email;
                            usuario.senha = senha;
                            usuario.telefone = telefone;
                            usuario.whatsapp = whatsapp;
                            usuario.endereco = endereco;
                            usuario.bairro = bairro;
                            usuario.cidade = cidade;
                            usuario.pontoReferencia = pontoReferencia;
                            _cadastraUsuario(usuario);
                            setState(() {
                              _mensagemErro = "";
                            });
                          } else {
                            setState(() {
                              _mensagemErro =
                                  "Preencha o campo Ponto de referência";
                            });
                          }
                        } else {
                          setState(() {
                            _mensagemErro = "Preencha o campo Whatsapp";
                          });
                        }
                      } else {
                        setState(() {
                          _mensagemErro = "Preencha o campo cidade";
                        });
                      }
                    } else {
                      setState(() {
                        _mensagemErro = "Preencha o campo bairro";
                      });
                    }
                  } else {
                    setState(() {
                      _mensagemErro = "Preencha o campo endereco";
                    });
                  }
                } else {
                  setState(() {
                    _mensagemErro = "Preencha o campo telefone";
                  });
                }
              } else {
                setState(() {
                  _mensagemErro = "A senha deve ter mais de 6 caracteres";
                });
              }
            } else {
              setState(() {
                _mensagemErro = "Senha não confere";
              });
            }
          } else {
            setState(() {
              _mensagemErro = "Preencha o campo senha";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Preencha o campo email corretamente";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha o campo email";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o campo nome";
      });
    }
  }

  _cadastraUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((user) async {
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      var playerId = status.subscriptionStatus.userId;
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("usuarios").doc(user.user.uid).set({
        "idUsuario": user.user.uid,
        "playerId": playerId,
        "nome": usuario.nome,
        "email": usuario.email,
        "telefone": usuario.telefone,
        "whatsapp": usuario.whatsapp,
        "endereco": usuario.endereco,
        "bairro": usuario.bairro,
        "cidade": usuario.cidade,
        "pontoReferencia": usuario.pontoReferencia,
        "adm": false,
      });
      Navigator.popAndPushNamed(context, "/carrinho");
    }).catchError((erro) {
      setState(() {
        _mensagemErro =
            "Erro ao cadastrar o usuário, verificar os campos novamente!";
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      "images/user.png",
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
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Nome completo",
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
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerEmail,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[_mascaraTelefone],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                          hintText: "Whatsapp",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerWhatsapp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[_mascaraTelefone],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                          hintText: "Telefone",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerTelefone,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Endereço",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerEndereco,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Bairro",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerBairro,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Cidade",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerCidade,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Ponto de referência",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerPontoReferencia,
                    ),
                  ),
                  TextField(
                    obscureText: !_motrarSenha,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _motrarSenha ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _motrarSenha = !_motrarSenha;
                            });
                          },
                        ),
                        hintText: "Senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerSenha,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: TextField(
                      obscureText: !_motrarSenhaConfirma,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: _motrarSenhaConfirma
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _motrarSenhaConfirma = !_motrarSenhaConfirma;
                              });
                            },
                          ),
                          hintText: "Digite novamente a senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerConfirmaSenha,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Color(0xffFF0000),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        _validarCampos();
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
                ]),
          ),
        ),
      ),
    );
  }
}
