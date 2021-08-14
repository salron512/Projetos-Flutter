import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AlteraCadastro extends StatefulWidget {
  @override
  _AlteraCadastroState createState() => _AlteraCadastroState();
}

class _AlteraCadastroState extends State<AlteraCadastro> {
  var _mascaraTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var _mascaraCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  String _msgErro = "";

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerWhatsapp = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerCpf = TextEditingController();
  List<String> listaCidades = ["Mirassol d'Oeste"];
  String _cidade = '';

  _recuperaDadosUsuaurio() async {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    Map<String, dynamic> dadosUsuario;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("usuarios").doc(uid).get();
    dadosUsuario = snapshot.data();
    _controllerNome.text = dadosUsuario["nome"];
    _controllerTelefone.text = dadosUsuario["telefone"];
    _controllerWhatsapp.text = dadosUsuario["whatsapp"];
    _controllerEndereco.text = dadosUsuario["endereco"];
    _controllerBairro.text = dadosUsuario["bairro"];
    _controllerCpf.text = dadosUsuario["cpf"];
    setState(() {
      _cidade = dadosUsuario["cidade"];
    });
  }

  _verificaCampos() {
    String nome = _controllerNome.text;
    String telefone = _controllerTelefone.text;
    String whatsapp = _controllerWhatsapp.text;
    String endereco = _controllerEndereco.text;
    String bairro = _controllerBairro.text;
    String cpf = _controllerCpf.text;

    if (nome.isNotEmpty) {
      if (telefone.isNotEmpty) {
        if (whatsapp.isNotEmpty) {
          if (endereco.isNotEmpty) {
            if (bairro.isNotEmpty) {
              if (cpf.isNotEmpty) {
                String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
                FirebaseFirestore.instance
                    .collection("usuarios")
                    .doc(uid)
                    .update({
                  "nome": nome,
                  "telefone": telefone,
                  "whatsapp": whatsapp,
                  "endereco": endereco,
                  "bairro": bairro,
                  'cpf': cpf,
                  "cidade": _cidade,
                }).then((value) => Navigator.pushNamedAndRemoveUntil(
                        context, "/home", (route) => false));
              } else {
                setState(() {
                  _msgErro = "Por favor preencha o campo cpf";
                });
              }
            } else {
              setState(() {
                _msgErro = "Por favor preencha o campo bairro";
              });
            }
          } else {
            setState(() {
              _msgErro = "Por favor preencha o campo endereco";
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
    _escolhaMenuCidade(String cidadeEscolhida) {
    setState(() {
      _cidade = cidadeEscolhida;
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaDadosUsuaurio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualizar cadastro"),
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
                    controller: _controllerCpf,
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
                    )
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
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Atualizar",
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
