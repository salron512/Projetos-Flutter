import 'package:acha_eu/model/Usuario.dart';
import 'package:acha_eu/util/ListaEstado.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
  TextEditingController _controllerWhatsapp = TextEditingController();
  List<String> _listaEstado = ListaEstado.LISTAESTADO;
  List<String> _listaCidades;
  String _scolhaEstado = "";
  String _mensagemErro = "";
  String _escolhaCidade = "";
  bool _motrarSenha = false;
  bool _motrarSenhaConfirma = false;


  _validarCampos() {
    //verifica campo da tela de cadastro
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String confirmaSenha = _controllerConfirmaSenha.text;
    String telefone = _controllerTelefone.text;
    String estado = _scolhaEstado;
    String cidade = _escolhaCidade;
    String whatsapp = _controllerWhatsapp.text;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length > 6) {
          if (senha == confirmaSenha) {
            if (telefone.isNotEmpty) {
              if (_scolhaEstado.isNotEmpty) {
                if (_escolhaCidade.isNotEmpty) {
                 if(whatsapp.isNotEmpty){
                   Usuario usuario = Usuario();
                   usuario.nome = nome;
                   usuario.email = email;
                   usuario.senha = senha;
                   usuario.telefone = telefone;
                   usuario.estado = estado;
                   usuario.cidade = cidade;
                   usuario.categoriaUsuario = "Cliente";
                   usuario.whatsapp = whatsapp;
                   usuario.mostraPagamento = false;
                   usuario.adm = false;
                   setState(() {
                     _mensagemErro = "";
                   });
                   _cadastrarUsuairo(usuario);
                 }else{
                   setState(() {
                     _mensagemErro = "Preencha o campo whatsapp";
                   });
                 }
                } else {
                  setState(() {
                    _mensagemErro = "Escolha sua cidade";
                  });
                }
              } else {
                setState(() {
                  _mensagemErro = "Escolha seu estado";
                });
              }
            } else {
              setState(() {
                _mensagemErro = "Preencha o campo telefone";
              });
            }
          } else {
            setState(() {
              _mensagemErro = "Senha não conferer";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Preencha a senha corretamente";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha o e-mail corretamente";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }
  }

  _cadastrarUsuairo(Usuario usuario) {
    //cadastra usuario
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebase) async {
      FirebaseFirestore db = FirebaseFirestore.instance;
      // salva dados do usuario no Firebase
      await db
          .collection("usuarios")
          .doc(firebase.user.uid)
          .set(usuario.toMap());
          //insere o campo do id do usuario
      await db
          .collection("usuarios")
          .doc(firebase.user.uid)
          .update({"idUsuario": firebase.user.uid});
      _cadastraNotificacao(firebase.user.uid);

      Navigator.pushNamedAndRemoveUntil(
          context, "/listacategorias", (_) => false);
    }).catchError((error) {
      setState(() {
        _mensagemErro =
            "Erro ao cadastrar o usuário, verificar os campos novamente!";
      });
    });
  }
  _cadastraNotificacao(String idUsuario) async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    db.collection("usuarios")
        .doc(idUsuario)
        .update({"playerId": playerId});

  }

  _mostraListaEstado() {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Escolha seu estado"),
            content: Container(
              width: 100,
              height: 250,
              child:  ListView.separated(
                shrinkWrap: true,
                itemCount: _listaEstado.length,
                separatorBuilder: (context, indice) => Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                // ignore: missing_return
                itemBuilder: (context, indice) {
                  String item = _listaEstado[indice];
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      _recuperaListaCidade(item);
                      setState(() {
                        _scolhaEstado = item;
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }

  _recuperaListaCidade(String estado) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var dados =
        await db.collection("cidades").where("estado", isEqualTo: estado).get();

    List<String> listaCidadesRecuperadas = List();
    for (var item in dados.docs) {
      var dados = item.data();
      print("teste for: " + dados["cidade"].toString());
      listaCidadesRecuperadas.add(dados["cidade"]);
    }
    setState(() {
      _listaCidades = listaCidadesRecuperadas;
    });
    _mostraListaCidade();
  }

  _mostraListaCidade() {
    if (_listaCidades.isNotEmpty) {
      var item;
      showDialog(
        barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Escolha sua cidade"),
              content: Container(
                width: 100,
                height: 250,
                child:  ListView.separated(
                  shrinkWrap: true,
                  itemCount: _listaCidades.length,
                  separatorBuilder: (context, indice) => Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  // ignore: missing_return
                  itemBuilder: (context, indice) {
                    String item = _listaCidades[indice];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          _escolhaCidade = item;
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ),
              ),
            );
          });
      setState(() {
        _mensagemErro = "";
      });
    } else {
      setState(() {
        _mensagemErro = "escolha o estado primeiro";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _recuperaListaApi();
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
                              borderRadius: BorderRadius.circular(32))),
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
                              borderRadius: BorderRadius.circular(32))),
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
                              borderRadius: BorderRadius.circular(32))),
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
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerTelefone,
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
                            borderRadius: BorderRadius.circular(32))),
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
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerConfirmaSenha,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_location_outlined,
                            ),
                            Text(
                              "Escolha seu estado: " + _scolhaEstado,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        onTap: () {
                          _mostraListaEstado();
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_location_outlined,
                          ),
                          Text(
                            "Escolha sua cidade: " + _escolhaCidade,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                      child: Text(
                        "Cadastrar",
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
