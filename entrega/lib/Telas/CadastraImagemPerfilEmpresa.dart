import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class CadastraImagemPerfilEmpresa extends StatefulWidget {
  String id;
  CadastraImagemPerfilEmpresa(this.id);

  @override
  _CadastraImagemPerfilEmpresaState createState() =>
      _CadastraImagemPerfilEmpresaState();
}

class _CadastraImagemPerfilEmpresaState
    extends State<CadastraImagemPerfilEmpresa> {
  bool _subindoImagem = false;
  String _urlImagem;
  File _imagem;
  bool _imagemPerfil = false;
  List<String> listaImagens = [];

  Future _recuperaImagem(bool daCamera) async {
    var picker = ImagePicker();
    PickedFile imagemSelecionada;
    File imagem;
    if (daCamera) {
      //recupera imagem da camera
      imagemSelecionada = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        // maxHeight: 500,
        // maxWidth: 500,
      );
      if (imagemSelecionada != null) {
        imagem = File(imagemSelecionada.path);
      }
    } else {
      //recupera imagem da galeria
      imagemSelecionada = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        //maxHeight: 500,
        //  maxWidth: 500,
      );
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

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    var pastaRaiz = storage.ref();
    var arquivo =
        pastaRaiz.child("empresas").child(widget.id).child("perfil" + ".jpg");
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
      setState(() {
        _imagemPerfil = true;
      });
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

  _atualizarUrlIamgemFirestore(String url) {
    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("usuarios").doc(widget.id).update(dadosAtualizar);
  }

  _recuperaImagemPeril() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var snap = await db.collection("usuarios").doc(widget.id).get();

    Map<String, dynamic> dadosRecuperados = snap.data();

    setState(() {
      _urlImagem = dadosRecuperados["urlImagem"];
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaImagemPeril();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                child: _urlImagem == null
                    ? Image.asset("images/error.png")
                    : CachedNetworkImage(
                      imageUrl: _urlImagem ,
                    )
                    //Image.network(_urlImagem),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Visibility(
                  visible: _subindoImagem,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                    child: Text("Camera"),
                    onPressed: () {
                      _recuperaImagem(true);
                    },
                  ),
                  TextButton(
                    child: Text("Galeria"),
                    onPressed: () {
                      _recuperaImagem(false);
                    },
                  ),
                ]),
              ),
            ],
          )),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Visibility(
                    visible: _imagemPerfil,
                    child: IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/home", (route) => false);
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  )),
            ],
          )),
    );
  }
}
