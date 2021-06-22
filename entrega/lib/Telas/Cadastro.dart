import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  var _mascaraTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var _mascaraCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  bool _mostrarSenha = false;
  bool _motrarSenhaConfirma = false;
  String _msgErro = "";
  List<String> listaCidades = ["Mirassol d'Oeste"];
  String _cidade = '';

  _escolhaMenuCidade(String cidadeEscolhida) {
    setState(() {
      _cidade = cidadeEscolhida;
    });
  }

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerWhatsapp = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmaSenha = TextEditingController();
  TextEditingController _controllerCpf = TextEditingController();

  _verificaCampos() async {
    String nome = _controllerNome.text;
    String telefone = _controllerTelefone.text;
    String whatsapp = _controllerWhatsapp.text;
    String endereco = _controllerEndereco.text;
    String bairro = _controllerBairro.text;
    String senha = _controllerSenha.text;
    String confirmaSenha = _controllerConfirmaSenha.text;
    String email = _controllerEmail.text;
    String cpf = _controllerCpf.text;

    if (nome.isNotEmpty) {
      if (telefone.isNotEmpty) {
        if (whatsapp.isNotEmpty) {
          if (endereco.isNotEmpty) {
            if (bairro.isNotEmpty) {
              if (senha.isNotEmpty) {
                if (senha.length > 6) {
                  if (senha == confirmaSenha) {
                    if (email.isNotEmpty) {
                      if (email.contains("@")) {
                        if (_cidade.isNotEmpty) {
                          if (cpf.isNotEmpty) {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: senha)
                                .then((value) async {
                              String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
                              await FirebaseFirestore.instance
                                  .collection("usuarios")
                                  .doc(uid)
                                  .set({
                                "tipoUsuario": "cliente",
                                "nome": nome,
                                "email": email,
                                "telefone": telefone,
                                "whatsapp": whatsapp,
                                "endereco": endereco,
                                "bairro": bairro,
                                "cidade": _cidade,
                                'cpf': _mascaraCpf.unmaskText(cpf),
                              }).then((value) async {
                                String uid =
                                    RecuperaFirebase.RECUPERAIDUSUARIO();
                                var status = await OneSignal.shared
                                    .getPermissionSubscriptionState();
                                String playerId =
                                    status.subscriptionStatus.userId;
                                FirebaseFirestore.instance
                                    .collection("usuarios")
                                    .doc(uid)
                                    .update({
                                  "playerId": playerId,
                                });
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/home", (route) => false);
                              });
                            }).catchError((erro) {
                              setState(() {
                                _msgErro = "Falha ao cadastrar, por favor" +
                                    "verifique suas informações";
                              });
                            });
                          } else {
                            setState(() {
                              _msgErro = 'Por favor preencha o campo cpf';
                            });
                          }
                        } else {
                          setState(() {
                            _msgErro = "Por favor escolha uma cidade";
                          });
                        }
                      } else {
                        setState(() {
                          _msgErro = "E-mail inválido";
                        });
                      }
                    } else {
                      setState(() {
                        _msgErro = "Por favor preencha o campo senha";
                      });
                    }
                  } else {
                    setState(() {
                      _msgErro = "Senha não confere digite novamente";
                    });
                  }
                } else {
                  setState(() {
                    _msgErro = "A senha teve ter mais de seis caracteres";
                  });
                }
              } else {
                setState(() {
                  _msgErro = "Por favor preencha o campo senha";
                });
              }
            } else {
              setState(() {
                _msgErro = "Por favor preencha o campo bairro";
              });
            }
          } else {
            setState(() {
              _msgErro = "Por favor preencha o campo endereço";
            });
          }
        } else {
          setState(() {
            _msgErro = "Por favor preencha o campo whatsapp";
          });
        }
      } else {
        setState(() {
          _msgErro = "Por favor preencha o campo telefone";
        });
      }
    } else {
      setState(() {
        _msgErro = "Por favor preencha o campo nome";
      });
    }
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
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 15),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: Image.asset("images/man.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "E-mail",
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
                    inputFormatters: [_mascaraTelefone],
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.sentences,
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
                        labelText: "Telefone",
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
                      inputFormatters: [_mascaraCpf],
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: "Cpf",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerCpf),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    inputFormatters: [_mascaraTelefone],
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.sentences,
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
                        labelText: "Whatsapp",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerWhatsapp,
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
                          labelText: "Endereço",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerEndereco),
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
                          labelText: "Bairro",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerBairro),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    obscureText: !_mostrarSenha,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _mostrarSenha ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                        hintText: "Digite a senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerSenha,
                  ),
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
                        hintText: "Digite a senha novamente",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerConfirmaSenha,
                  ),
                ),
                Text(
                  _msgErro,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: PopupMenuButton<String>(
                      color: Color(0xff37474f),
                      icon: Text("Escolha sua cidade"),
                      onSelected: _escolhaMenuCidade,
                      // ignore: missing_return
                      itemBuilder: (context) {
                        return listaCidades.map((String item) {
                          return PopupMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: TextStyle(color: Colors.white)),
                          );
                        }).toList();
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Cidade escolhida: " + _cidade),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      _verificaCampos();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
