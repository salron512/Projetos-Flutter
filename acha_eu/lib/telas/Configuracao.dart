import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Configuracao extends StatefulWidget {
  @override
  _ConfiguracaoState createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  TextEditingController _controllerNome = TextEditingController(text: "");
  TextEditingController _controllerTelefone = TextEditingController(text: "");
  File _imagem;
  String _idUsuarioLogado = "";
  bool _subindoImagem = false;
  String _urlImagem = "";
  String _escolhaCidade = "";
  String _escolhaCategoria = "";
  String _scolhaEstado = "";
  List<String> _listaCidades;
  List<String> _listaCadegorias;
  var cond;
  List<String> _listaEstado = ["MT", "MS"];
  Future _recuperaImagem(bool daCamera) async {
    var picker = ImagePicker();
    PickedFile imagemSelecionada;
    File imagem;
    if (daCamera) {
      // ignore: deprecated_member_use
      imagemSelecionada =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
      imagem = File(imagemSelecionada.path);
    } else {
      // ignore: deprecated_member_use
      imagemSelecionada =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
      imagem = File(imagemSelecionada.path);
    }
    setState(() {
      _imagem = imagem;
      if (_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    var pastaRaiz = storage.ref();
    var arquivo = pastaRaiz.child("perfil").child(_idUsuarioLogado + ".jpg");
    UploadTask task = arquivo.putFile(_imagem);
    task.snapshotEvents.listen((TaskSnapshot storageTaskEvent) {
      if (storageTaskEvent.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageTaskEvent.state == TaskState.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    //recupera a url da imagem
    task.whenComplete(() {}).then((snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlIamgemFirestore(url);

    setState(() {
      _urlImagem = url;
    });
  }

  _atualizarNomeFirestore() {
    String nome = _controllerNome.text;
    String telefone = _controllerTelefone.text;
    String estado = _scolhaEstado;
    String cidade = _escolhaCidade;
    String categoria = _escolhaCategoria;
    Map<String, dynamic> dadosAtualizar = {
      "nome": nome,
      "telefone": telefone,
      "estado": estado,
      "cidade": cidade,
      "categoria": categoria,
    };

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);

    Navigator.pushNamed(context, "/listacategorias");
  }

  _atualizarUrlIamgemFirestore(String url) {
    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
  }

  _recuperaCategorias() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var snapshot = await db
        .collection("categorias")
        .orderBy("categoria", descending: false)
        .get();
    List<String> listarecuperada = List();
    for (var item in snapshot.docs) {
      Map<String, dynamic> dados = item.data();
      listarecuperada.add(dados["categoria"]);
    }
    setState(() {
      _listaCadegorias = listarecuperada;
    });
  }

  _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = await auth.currentUser;
    _idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    var snapshot = await db.collection("usuarios").doc(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data();
    cond = dados;
    _controllerNome.text = dados["nome"];
    _controllerTelefone.text = dados["telefone"];
    _scolhaEstado = dados["estado"];
    _escolhaCategoria = dados["categoria"];
    print("estado: " + _scolhaEstado);
    _escolhaCidade = dados["cidade"];
    if (dados["urlImagem"] != null) {
      setState(() {
        _urlImagem = dados["urlImagem"];
      });
    }
    _recuperaListaCidades();
  }

  _mostraListaEstado() {
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
                    setState(() {
                      _listaCidades.clear();
                      _scolhaEstado = item;
                      Navigator.pop(context);
                    });
                    _recuperaListaCidades();
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

  _mostraListaCidade() {
    if (_listaCidades.isNotEmpty) {
      var item;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Escolha sua cidade"),
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
    } else {}
  }

  _mostraListaCategorias() {
    if (_listaCidades.isNotEmpty) {
      var item;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Escolha sua categoria de serviço"),
              content: ListView.separated(
                itemCount: _listaCadegorias.length,
                separatorBuilder: (context, indice) => Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                // ignore: missing_return
                itemBuilder: (context, indice) {
                  String item = _listaCadegorias[indice];
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        _escolhaCategoria = item;
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
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
    _recuperaCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: cond == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: _subindoImagem
                        ? CircularProgressIndicator()
                        : Container(),
                  ),
                  CircleAvatar(
                      backgroundImage:
                          _urlImagem != null ? NetworkImage(_urlImagem) : null,
                      maxRadius: 100,
                      backgroundColor: Colors.grey),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          child: Text(
                            "Câmera",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            _recuperaImagem(true);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Galeria",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            _recuperaImagem(false);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerNome,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerTelefone,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_location_outlined,
                            ),
                            Text(
                              "Seu estado: " + _scolhaEstado,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        onTap: () {
                          _mostraListaEstado();
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: GestureDetector(
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_location_outlined,
                          ),
                          Text(
                            "Sua cidade: " + _escolhaCidade,
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
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: GestureDetector(
                      child: Row(
                        children: [
                          Icon(
                            Icons.work,
                          ),
                          Text(
                            "Sua gategoria de serviço: " + _escolhaCategoria,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        _recuperaCategorias();
                        _mostraListaCategorias();
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _atualizarNomeFirestore();
                    },
                  ),
                ],
              )),
            ),
    );
  }
}
