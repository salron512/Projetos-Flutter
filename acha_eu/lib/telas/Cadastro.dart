import 'package:acha_eu/model/Usuario.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmaSenha = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  List<String> _listaEstado = ["MT", "MS"];
  List<String> _listaCidades;
  String _scolhaEstado = "";
  String _mensagemErro = "";
  String _escolhaCidade = "";

  _validarCampos() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String confirmaSenha = _controllerConfirmaSenha.text;
    String telefone = _controllerTelefone.text;
    String estado = _scolhaEstado;
    String cidade = _escolhaCidade;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length > 6) {
          if (senha == confirmaSenha) {
            setState(() {
              _mensagemErro = "";
            });

            Usuario usuario = Usuario();
            usuario.nome = nome;
            usuario.email = email;
            usuario.senha = senha;
            usuario.telefone = telefone;
            usuario.estado = estado;
            usuario.cidade = cidade;
            usuario.categoriaUsuario = "cliente";
            _cadastrarUsuairo(usuario);
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

  _recuperaListaCidades() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var dados = await db
        .collection("cidades")
        .where("estado", isEqualTo: _scolhaEstado)
        .get();

    List<String> listaCidadesRecuperadas = List();
    for (var item in dados.docs) {
      var dados = item.data();
      print("teste for: " + dados["cidade"].toString());
      listaCidadesRecuperadas.add(dados["cidade"]);
    }
    setState(() {
      _listaCidades = listaCidadesRecuperadas;
    });
  }


  _cadastrarUsuairo(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebase) {
      FirebaseFirestore db = FirebaseFirestore.instance;

      db.collection("usuarios").doc(firebase.user.uid).set(usuario.toMap());

      Navigator.pushNamedAndRemoveUntil(
          context, "/listacategorias", (_) => false);

      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((error) {
      setState(() {
        _mensagemErro =
            "Erro ao cadastrar o usuário, verificar os campos novamente!";
      });
    });
  }


  _mostraListaEstado() {
    var item;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Escolha seu estado"),
            content: ListView.separated(
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
                    _recuperaListaCidades();
                    setState(() {
                      _scolhaEstado = item;
                      Navigator.pop(context);
                    });
                  },
                );
              },
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

  _mostraListaCidade() {
    if (_listaCidades.isNotEmpty) {
      var item;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Escolha seu estado"),
              content: ListView.separated(
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
                      _recuperaListaCidades();
                      setState(() {
                        _escolhaCidade = item;
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              ),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
              ],
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Telefone",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerTelefone,
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                      )
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
                            "Escolha sua cidade: " + _escolhaCidade,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        _mostraListaCidade();
                      },
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
