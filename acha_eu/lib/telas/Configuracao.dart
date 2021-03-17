import 'dart:io';
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
  TextEditingController _controllerWhatsapp = TextEditingController();
  File _imagem;
  String _idUsuarioLogado = "";
  bool _subindoImagem = false;
  String _urlImagem = "";
  String _escolhaCidade = "";
  String _escolhaCategoria = "";
  String _scolhaEstado = "";
  List<String> _listaCidades;
  List<String> _listaCadegorias;
  bool _dinheiro = false;
  bool _cartaoDebito = false;
  bool _cartaoCredito = false;
  bool _cheque = false;
  bool _pix = false;
  bool _mostraPagamento = true;
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
    String whatsapp = _controllerWhatsapp.text;
    String estado = _scolhaEstado;
    String cidade = _escolhaCidade;
    String categoria = _escolhaCategoria;
    bool dinheiro = _dinheiro;
    bool cartaoCredito = _cartaoCredito;
    bool cartaoDebito = _cartaoDebito;
    bool cheque = _cheque;
    bool pix = _pix;

    Map<String, dynamic> dadosAtualizar = {
      "nome": nome,
      "telefone": telefone,
      "whatsapp": whatsapp,
      "estado": estado,
      "cidade": cidade,
      "categoria": categoria,
      "dinheiro": dinheiro,
      "cartaoCredito": cartaoCredito,
      "cartaoDebito": cartaoDebito,
      "cheque": cheque,
      "pix": pix,
    };

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);

    Navigator.pushNamedAndRemoveUntil(
        context, "/listacategorias", (route) => false);
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
    _controllerWhatsapp.text = dados["whatsapp"];
    print("estado: " + _scolhaEstado);
    _escolhaCidade = dados["cidade"];
    if (dados["urlImagem"] != null) {
      setState(() {
        _urlImagem = dados["urlImagem"];
      });
    }
    _recuperaListaCidades();
    _verificaFormaPagamento(snapshot);
  }

  _verificaFormaPagamento(DocumentSnapshot snapshot) {
    Map<String, dynamic> dados = snapshot.data();
    setState(() {
      _dinheiro = dados["dinheiro"];
      _cheque = dados["cheque"];
      _cartaoDebito = dados["cartaoDebito"];
      _cartaoCredito = dados["cartaoCredito"];
      _pix = dados["pix"];
    });
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
  _mostraOpcoesPagamento() {
    if (_escolhaCategoria == "cliente") {
      setState(() {
        _mostraPagamento = false;
      });
    }else{
      setState(() {
        _mostraPagamento = true;
      });
    }
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
                      });
                      Navigator.pop(context);
                      _mostraOpcoesPagamento();
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
    _mostraOpcoesPagamento();
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
          : Container(
              decoration: BoxDecoration(color: Color(0xffDCDCDC)),
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: _subindoImagem
                            ? CircularProgressIndicator()
                            : Container(),
                      ),
                      CircleAvatar(
                          backgroundImage: _urlImagem != null
                              ? NetworkImage(_urlImagem)
                              : null,
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
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              labelText: "Nome",
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              filled: true,
                              fillColor: Color(0xffDCDCDC),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          controller: _controllerNome,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              labelText: "Telefone",
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              filled: true,
                              fillColor: Color(0xffDCDCDC),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          controller: _controllerTelefone,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              labelText: "Whatsapp",
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              filled: true,
                              fillColor: Color(0xffDCDCDC),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          controller: _controllerWhatsapp,
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Icon(
                                Icons.work,
                              ),
                              Text(
                                "Sua gategoria de serviço: " +
                                    _escolhaCategoria,
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
                      Visibility(
                        visible: _mostraPagamento,
                        child: Container(
                            alignment: Alignment.center,
                            height: 310,
                            decoration: BoxDecoration(
                                color: Color(0xffDCDCDC),
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Formas de pagamento:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        activeColor: Colors.green,
                                        value: _dinheiro,
                                        onChanged: (value) {
                                          setState(() {
                                            _dinheiro = value;
                                          });
                                        }),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 15, right: 5),
                                        child: Icon(
                                          Icons.payments_outlined,
                                          color: Colors.green,
                                        )),
                                    Text(
                                      "Dinheiro",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        activeColor: Colors.green,
                                        value: _cartaoCredito,
                                        onChanged: (value) {
                                          setState(() {
                                            _cartaoCredito = value;
                                          });
                                        }),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 15, right: 5),
                                        child: Icon(
                                          Icons.credit_card,
                                          color: Colors.blue,
                                        )),
                                    Text(
                                      "Cartão de credito",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        activeColor: Colors.green,
                                        value: _cartaoDebito,
                                        onChanged: (value) {
                                          setState(() {
                                            _cartaoDebito = value;
                                          });
                                        }),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 15, right: 5),
                                        child: Icon(
                                          Icons.credit_card,
                                          color: Colors.red,
                                        )),
                                    Text(
                                      "Cartão de debito",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        activeColor: Colors.green,
                                        value: _cheque,
                                        onChanged: (value) {
                                          setState(() {
                                            _cheque = value;
                                          });
                                        }),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 15, right: 5),
                                        child: Icon(
                                          Icons.account_balance_outlined,
                                          color: Colors.orange,
                                        )),
                                    Text(
                                      "Cheque",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        activeColor: Colors.green,
                                        value: _pix,
                                        onChanged: (value) {
                                          setState(() {
                                            _pix = value;
                                          });
                                        }),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 15, right: 5),
                                        child: Icon(
                                          Icons.payment_outlined,
                                          color: Colors.purple,
                                        )),
                                    Text(
                                      "Pix",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: RaisedButton(
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
                      ),
                    ],
                  )),
            ),
    );
  }
}