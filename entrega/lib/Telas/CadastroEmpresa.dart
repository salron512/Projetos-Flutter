import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroEmpresa extends StatefulWidget {
  @override
  _CadastroEmpresaState createState() => _CadastroEmpresaState();
}

class _CadastroEmpresaState extends State<CadastroEmpresa> {
  var _mascaraTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var _mascaraCnpj = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  var _mascaraHorario =
      MaskTextInputFormatter(mask: '##:##', filter: {"#": RegExp(r'[0-9]')});
  String _msgErro = "";
  String _escolhaCategoria = "";
  List<String> itensMenu = [];
  bool _mostrarSenha = false;
  bool _motrarSenhaConfirma = false;
  List<String> listaCidades = ["Mirassol D'Oeste"];
  String _cidade = "";
  TextEditingController _controllerRazaoSocial = TextEditingController();
  TextEditingController _controllerNomeFantasia = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerCnpj = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerHoraAbertura = TextEditingController();
  TextEditingController _controllerHoraFechamento = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmaSenha = TextEditingController();
  TextEditingController _controllerDiasFuncionamento = TextEditingController();

  _escolhaMenuItem(String itemEscolhido) {
    setState(() {
      _escolhaCategoria = itemEscolhido;
    });
  }

  _escolhaMenuCidade(String cidadeEscolhida) {
    setState(() {
      _cidade = cidadeEscolhida;
    });
  }

  _verificaCampos() async {
    String idUsurio;
    String razaoSocial = _controllerRazaoSocial.text;
    String nomeFantasia = _controllerNomeFantasia.text;
    String email = _controllerEmail.text;
    String telefone = _controllerTelefone.text;
    String cnpj = _controllerCnpj.text;
    String endereco = _controllerEndereco.text;
    String bairro = _controllerBairro.text;
    String hAbertura = _controllerHoraAbertura.text;
    String hFechamento = _controllerHoraFechamento.text;
    String senha = _controllerSenha.text;
    String confirmarSenha = _controllerConfirmaSenha.text;
    String diasFuncionamento = _controllerDiasFuncionamento.text;

    if (razaoSocial.isNotEmpty) {
      if (nomeFantasia.isNotEmpty) {
        if (telefone.isNotEmpty) {
          if (cnpj.isNotEmpty) {
            if (endereco.isNotEmpty) {
              if (bairro.isNotEmpty) {
                if (hAbertura.isNotEmpty) {
                  if (hFechamento.isNotEmpty) {
                    if (_escolhaCategoria.isNotEmpty) {
                      if (senha.isNotEmpty) {
                        if (confirmarSenha.isNotEmpty) {
                          if (senha == confirmarSenha) {
                            if (_escolhaCategoria.isNotEmpty) {
                              if (_cidade.isNotEmpty) {
                                if (diasFuncionamento.isNotEmpty) {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: email, password: senha)
                                      .then((value) {
                                    idUsurio = value.user.uid;
                                    FirebaseFirestore.instance
                                        .collection("usuarios")
                                        .doc(idUsurio)
                                        .set({
                                      "idEmpresa": idUsurio,
                                      "adm": false,
                                      "razaoSocial": razaoSocial,
                                      "nomeFantasia": nomeFantasia,
                                      "empresa": true,
                                      "ativa": true,
                                      "telefone": telefone,
                                      "cnpj": cnpj,
                                      "endereco": endereco,
                                      "bairro": bairro,
                                      "cidade": _cidade,
                                      "hAbertura": hAbertura,
                                      "hFechamento": hFechamento,
                                      "diasFunc": diasFuncionamento,
                                      "categoria": _escolhaCategoria,
                                      "urlImagem": null,
                                    });
                                  }).catchError((erro) {
                                    setState(() {
                                      _msgErro =
                                          "Falha ao salvar o cadastro por"
                                          "favor verifique sua conexão";
                                    });
                                  });
                                  Navigator.pushNamed(
                                      context, "/cadastroperfil",
                                      arguments: idUsurio);
                                } else {
                                  setState(() {
                                    _msgErro =
                                        "Por favor informe os dias de funcionamento ";
                                  });
                                }
                              } else {
                                setState(() {
                                  _msgErro = "Escolha uma cidade";
                                });
                              }
                            } else {
                              setState(() {
                                _msgErro = "Escolha uma categoria";
                              });
                            }
                          } else {
                            setState(() {
                              _msgErro = "Sua senha não confere";
                            });
                          }
                        } else {
                          setState(() {
                            _msgErro = "Por favor confirme sua senha";
                          });
                        }
                      } else {
                        setState(() {
                          _msgErro = "Por favor preencha o campo senha";
                        });
                      }
                    } else {
                      setState(() {
                        _msgErro = "Por favor escolha uma categoria";
                      });
                    }
                  } else {
                    setState(() {
                      _msgErro =
                          "Por favor preencha o campo horário de fechamento";
                    });
                  }
                } else {
                  setState(() {
                    _msgErro = "Por favor preencha o campo horário de abertura";
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
              _msgErro = "Por favor preencha o campo telefone";
            });
          }
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
    } else {
      setState(() {
        _msgErro = "Por favor preencha o campo razão social";
      });
    }
  }

  _recuperaCategorias() async {
    List<String> listaRecuperada = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("categorias").get();
    for (var item in querySnapshot.docs) {
      Map<String, dynamic> categorias = item.data();
      String categoria = categorias["categoria"];
      listaRecuperada.add(categoria);
    }
    setState(() {
      itensMenu = listaRecuperada;
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro empresas"),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Razão social",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerRazaoSocial,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Nome fantasia",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerNomeFantasia,
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
                        labelText: "Email",
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [_mascaraCnpj],
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
                              _controllerCnpj.clear();
                            });
                          },
                        ),
                        labelText: "Cnpj",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerCnpj,
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
                    controller: _controllerEndereco,
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
                        labelText: "Bairro",
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
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Dias de funciomento Ex: Seg á Sex",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerDiasFuncionamento,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [_mascaraHorario],
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
                              _controllerHoraAbertura.clear();
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Horário de abertura",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerHoraAbertura,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [_mascaraHorario],
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
                              _controllerHoraFechamento.clear();
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Horário de fechamento",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerHoraFechamento,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
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
                        labelText: "Digite a senha",
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
                        labelText: "Digite a senha novamente",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerConfirmaSenha,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: PopupMenuButton<String>(
                      color: Color(0xff37474f),
                      icon: Text("Escolha uma categoria"),
                      onSelected: _escolhaMenuItem,
                      // ignore: missing_return
                      itemBuilder: (context) {
                        return itensMenu.map((String item) {
                          return PopupMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: TextStyle(color: Colors.white)),
                          );
                        }).toList();
                      },
                    )),
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
                Text(
                  "Categoria selecionada: " + _escolhaCategoria,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  "Cidade selecionada: " + _cidade,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  _msgErro,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ),
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
