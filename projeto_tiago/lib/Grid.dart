import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Grid extends StatefulWidget {
  String id;
  Grid(this.id);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  // ignore: close_sinks
  StreamController _streamController = StreamController.broadcast();
  // ignore: unused_field
  bool _subindoImagem = false;
  // ignore: unused_field
  String _urlImagem = "";
  File _imagem;
  bool _permissao = false;
  String _tituloImagem = "";

  _recuperaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String id = auth.currentUser.uid;
    var snap = await db.collection("usuarios").doc(id).get();
    Map<String, dynamic> dados = snap.data();

    setState(() {
      _permissao = dados["adm"];
    });
  }

  _atualizarUrlIamgemFirestore(String url, String path) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("galeria")
        .doc(widget.id)
        .collection(widget.id)
        .doc(_tituloImagem)
        .set({
      "ordenador": DateTime.now().microsecondsSinceEpoch.toString(),
      "id": widget.id,
      "urlGaleria": url,
      "path": path,
    });
    setState(() {
      _permissao = true;
    });
  }

  // ignore: missing_return
  Future _recuperaGaleria() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db
        .collection("galeria")
        .doc(widget.id)
        .collection(widget.id)
        .orderBy("ordenador", descending: false)
        .snapshots();

    stream.listen((event) {
      _streamController.add(event);
    });
  }

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
      //  maxWidth: 500,
      );
      imagem = File(imagemSelecionada.path);
    } else {
      //recupera imagem da galeria
      imagemSelecionada = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        //maxHeight: 500,
       // maxWidth: 500,
      );
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
    _tituloImagem = DateTime.now().microsecondsSinceEpoch.toString();
    var arquivo = pastaRaiz
        .child("produtos")
        .child(widget.id)
        .child(_tituloImagem + ".jpg");
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
    String path = snapshot.ref.fullPath;
    _atualizarUrlIamgemFirestore(url, path);

    setState(() {
      _urlImagem = url;
    });
  }

  _apagaImagem(String id, String path) {
    if(_permissao){
      showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir imagem"),
            content: Container(
              height: 190,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/excluir.png"),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  FirebaseStorage storage = FirebaseStorage.instance;

                  db
                      .collection("galeria")
                      .doc(widget.id)
                      .collection(widget.id)
                      .doc(id)
                      .delete();

                  var pastaRaiz = storage.ref();
                  pastaRaiz.child(path).delete();
                  Navigator.pop(context);
                },
                child: Text("Excluir"),
              ),
            ],
          );
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperaUsuario();
    _recuperaGaleria();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Grid produto"),
        ),
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: StreamBuilder(
            stream: _streamController.stream,
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: Text("Sem conexão"),
                  );
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  QuerySnapshot querySnapshot = snapshot.data;
                  if (querySnapshot.docs.length == 0) {
                    return Center(
                      child: Text(
                        "Sem imagens na galeria",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    );
                  } else {
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      children: List.generate(
                          // ignore: missing_return
                          querySnapshot.docs.length, (indice) {
                        List<DocumentSnapshot> urls =
                            querySnapshot.docs.toList();
                        DocumentSnapshot dados = urls[indice];
                        return GestureDetector(
                          child: dados["urlGaleria"] == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor),
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                )
                              : Image.network(
                                  dados["urlGaleria"],
                                  fit: BoxFit.cover,
                                ),
                          onTap: () {
                            Navigator.pushNamed(context, "/imagem",
                                arguments: dados);
                          },
                          onLongPress: () {
                            _apagaImagem(dados.reference.id, dados["path"]);
                          },
                        );
                      }),
                    );
                  }
                  break;
              }
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Visibility(
              visible: _permissao,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: IconButton(
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: () {
                          _recuperaImagem(true);
                        },
                        icon: Icon(Icons.camera_alt_outlined)),
                  ),
                  IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () {
                        _recuperaImagem(false);
                      },
                      icon: Icon(Icons.photo_rounded)),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/listacategorias", (route) => false);
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              )),
        ));
  }
}
