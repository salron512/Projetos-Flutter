import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _subindoImagem = false;
  String _urlImagem = "";
  File _imagem;

  _atualizarUrlIamgemFirestore(String url) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("galeria").doc(widget.id).collection(widget.id).doc().set({
      "ordenador": DateTime.now().microsecondsSinceEpoch.toString(),
      "id": widget.id,
      "urlGaleria": url,
    });
    //_recuperaGaleria();
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
      imagemSelecionada =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
      imagem = File(imagemSelecionada.path);
    } else {
      //recupera imagem da galeria
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
    var arquivo =
        pastaRaiz.child("produtos").child("perfil").child(widget.id + ".jpg");
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

  @override
  void initState() {
    super.initState();
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
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor
          ),
          padding: EdgeInsets.all(15),
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
                      child: Text("Sem imagens na galeria"),
                    );
                  } else {
                   return
                         GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: List.generate(
                              // ignore: missing_return
                              querySnapshot.docs.length, (indice) {
                            List<DocumentSnapshot> urls =
                                querySnapshot.docs.toList();
                            DocumentSnapshot dados = urls[indice];
                           return Image.network(dados["urlGaleria"],
                             width: 700,
                             height: 700,
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
                        icon: Icon(Icons.camera_alt_outlined))),
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
                          context, "/carrinho", (route) => false);
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            )));
  }
}
