import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AlteraCadastroEmpresa extends StatefulWidget {
  @override
  _AlteraCadastroEmpresaState createState() => _AlteraCadastroEmpresaState();
}

class _AlteraCadastroEmpresaState extends State<AlteraCadastroEmpresa> {
  var _mascaraTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var _mascaraCnpj = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  var _mascaraHorario =
      MaskTextInputFormatter(mask: '##:##', filter: {"#": RegExp(r'[0-9]')});

  var _mascaraCep = MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  String _msgErro = "";
  String _escolhaCategoria = "";
  List<String> itensMenu = [];

  // ignore: unused_field
  bool _subindoImagem = false;
  bool _aberto = false;
  String _urlImagem;
  File _imagem;
  List<String> listaCidades = ["Mirassol d'Oeste"];
  String _cidade = "";
  TextEditingController _controllerRazaoSocial = TextEditingController();
  TextEditingController _controllerNomeFantasia = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerCnpj = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerHoraAbertura = TextEditingController();
  TextEditingController _controllerHoraFechamento = TextEditingController();
  TextEditingController _controllerDiasFuncionamento = TextEditingController();
  TextEditingController _controllerApiPamento = TextEditingController();
  TextEditingController _controllerCep = TextEditingController();
  TextEditingController _controllerMerchantid = TextEditingController();

  _verificaCampos() async {
    String idUsurio = RecuperaFirebase.RECUPERAIDUSUARIO();
    String razaoSocial = _controllerRazaoSocial.text;
    String nomeFantasia = _controllerNomeFantasia.text;
    String telefone = _controllerTelefone.text;
    String cnpj = _controllerCnpj.text;
    String endereco = _controllerEndereco.text;
    String bairro = _controllerBairro.text;
    String hAbertura = _controllerHoraAbertura.text;
    String hFechamento = _controllerHoraFechamento.text;
    String diasFuncionamento = _controllerDiasFuncionamento.text;
    String chaveApi = _controllerApiPamento.text;
    String merchantId = _controllerMerchantid.text;
    String cep = _controllerCep.text;

    if (razaoSocial.isNotEmpty) {
      if (nomeFantasia.isNotEmpty) {
        if (telefone.isNotEmpty) {
          if (cnpj.isNotEmpty) {
            if (endereco.isNotEmpty) {
              if (bairro.isNotEmpty) {
                if (hAbertura.isNotEmpty) {
                  if (hFechamento.isNotEmpty) {
                    if (diasFuncionamento.isNotEmpty) {
                      if (_cidade.isNotEmpty) {
                        if (_escolhaCategoria.isNotEmpty) {
                          if (cep.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection("usuarios")
                                .doc(idUsurio)
                                .update({
                              "razaoSocial": razaoSocial,
                              "nomeFantasia": nomeFantasia,
                              "telefone": telefone,
                              "cnpj": cnpj,
                              "endereco": endereco,
                              "bairro": bairro,
                              "cidade": _cidade,
                              "hAbertura": hAbertura,
                              "hFechamento": hFechamento,
                              "diasFunc": diasFuncionamento,
                              "categoria": _escolhaCategoria,
                              "aberto": _aberto,
                              'merchantId': merchantId,
                              'merchantKey': chaveApi
                            }).catchError((erro) {
                              setState(() {
                                setState(() {
                                  _msgErro =
                                      "Falha ao salvar verifique sua conexão";
                                });
                              });
                            });
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/home", (route) => false);
                          } else {
                            setState(() {
                              _msgErro = "Por favor preencha o cep";
                            });
                          }
                        } else {
                          setState(() {
                            _msgErro = "Por favor escolha uma categoria";
                          });
                        }
                      } else {
                        setState(() {
                          _msgErro = "Por favor escolha uma cidade";
                        });
                      }
                    } else {
                      setState(() {
                        _msgErro = "Por favor informe os dias de funcionamento";
                      });
                    }
                  } else {
                    setState(() {
                      _msgErro = "Por favor informe a hora de fechamento";
                    });
                  }
                } else {
                  setState(() {
                    _msgErro = "Por favor informe a hora de abertura";
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
              _msgErro = "Por favor preencha o campo cnpj";
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

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String idUsuarioLogado = RecuperaFirebase.RECUPERAIDUSUARIO();
    var pastaRaiz = storage.ref();
    var arquivo = pastaRaiz.child("perfil").child(idUsuarioLogado + ".jpg");
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

  //faz download da imagem
  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlIamgemFirestore(url);

    setState(() {
      _urlImagem = url;
    });
  }

  _atualizarUrlIamgemFirestore(String url) {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    FirebaseFirestore.instance.collection("usuarios").doc(uid).update({
      "urlImagem": url,
    });
  }

  Future _recuperaImagem(bool daCamera) async {
    var picker = ImagePicker();
    PickedFile imagemSelecionada;
    File imagem;
    if (daCamera) {
      //recupera imagem da camera
      imagemSelecionada =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
      if (imagemSelecionada != null) {
        imagem = File(imagemSelecionada.path);
      }
    } else {
      //recupera imagem da galeria
      imagemSelecionada =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
      if (imagemSelecionada != null) {
        imagem = File(imagemSelecionada.path);
      }
    }
    setState(() {
      _imagem = imagem;
      if (_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

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

  _recuperaDados() async {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    Map<String, dynamic> map;
    var snapshot =
        await FirebaseFirestore.instance.collection("usuarios").doc(uid).get();
    map = snapshot.data();
    setState(() {
      _urlImagem = map["urlImagem"];
      _controllerRazaoSocial.text = map["razaoSocial"];
      _controllerNomeFantasia.text = map["nomeFantasia"];
      _controllerTelefone.text = map["telefone"];
      _controllerCnpj.text = map["cnpj"];
      _controllerEndereco.text = map["endereco"];
      _controllerBairro.text = map["bairro"];
      _controllerDiasFuncionamento.text = map["diasFunc"];
      _controllerHoraAbertura.text = map["hAbertura"];
      _controllerHoraFechamento.text = map["hFechamento"];
      _cidade = map["cidade"];
      _escolhaCategoria = map["categoria"];
      _aberto = map["aberto"];
      _controllerApiPamento.text = map['merchantKey'];
      _controllerMerchantid.text = map['merchantId'];
      _controllerCep.text = map['cep'];
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualiza cadastro"),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: _urlImagem == null
                      ? Image.asset("images/error.png")
                      : Image.network(_urlImagem),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
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
                      TextButton(
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
                Row(
                  children: [
                    Text("Fechado"),
                    Switch(
                      activeColor: Theme.of(context).primaryColor,
                        value: _aberto,
                        onChanged: (bool valor) {
                          setState(() {
                            _aberto = valor;
                          });
                        }),
                    Text("Aberto"),
                  ],
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [_mascaraCep],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Cep",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerCep,
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
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Merchant ID",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerMerchantid,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Chave para pagamentos",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerApiPamento,
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
                    )
                    ),
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
                      "Atualizar",
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
