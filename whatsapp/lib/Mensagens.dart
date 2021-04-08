import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'model/Conversa.dart';

class Mensagens extends StatefulWidget {
  Usuario contato;

  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  String _idUsuarioLogado;
  String _urlImagem;
  String _nomeUsario;
  String _idUsuarioDestinatario;
  Firestore db = Firestore.instance;
  File _imagem;
  bool _subindoImagem = false;
  ScrollController _scrollController = ScrollController();

  TextEditingController _controllerMensagem = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;

    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";
      mensagem.data = DateTime.now().millisecondsSinceEpoch;

      _salvaMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
      _salvaMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);
      _salvarConversa(mensagem);
    }
  }

  _salvarConversa(Mensagem msg) {
    //salva para o remetente
    Conversa cRemetente = Conversa();
    cRemetente.idRemetente = _idUsuarioLogado;
    cRemetente.idDestinatario = _idUsuarioDestinatario;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.caminhoFoto = widget.contato.urlImagem;
    cRemetente.tipoMensagem = msg.tipo;
    cRemetente.salvar();

    //salva para o destinatario
    Conversa cDestinatario = Conversa();
    cDestinatario.idRemetente = _idUsuarioDestinatario;
    cDestinatario.idDestinatario = _idUsuarioLogado;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = _nomeUsario;
    cDestinatario.caminhoFoto = _urlImagem;
    cDestinatario.tipoMensagem = msg.tipo;
    cDestinatario.salvar();
  }

  _salvaMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection("mensagens")
        .document(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    _controllerMensagem.clear();
  }

  _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;

    __adicionarListenerMensagens();

    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idUsuarioLogado).get();
    var dados = snapshot.data;
    _nomeUsario = dados["nome"];
    _urlImagem = dados["urlImagem"];
  }

  _enviarFoto() async {
    File imagemSelecionada;
    // ignore: deprecated_member_use
    imagemSelecionada =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    if (imagemSelecionada != null) {
      _subindoImagem = true;
    }
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("mensagens")
        .child(_idUsuarioLogado)
        .child(nomeImagem + ".jpg");
    StorageUploadTask task = arquivo.putFile(imagemSelecionada);
    task.events.listen((StorageTaskEvent storageTaskEvent) {
      if (storageTaskEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageTaskEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });
    //recupera a url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    Mensagem mensagem = Mensagem();
    mensagem.idUsuario = _idUsuarioLogado;
    mensagem.mensagem = "";
    mensagem.urlImagem = url;
    mensagem.tipo = "imagem";
    mensagem.data = DateTime.now().millisecondsSinceEpoch;

    _salvaMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    _salvaMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);
  }

  Stream<QuerySnapshot> __adicionarListenerMensagens() {
    final stream = db
        .collection("mensagens")
        .document(_idUsuarioLogado)
        .collection(_idUsuarioDestinatario)
        .orderBy("data", descending: false)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
      Timer(Duration(seconds: 1), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite sua mensagem...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    prefixIcon: _subindoImagem
                        ? CircularProgressIndicator()
                        : IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: _enviarFoto,
                          )),
                controller: _controllerMensagem,
              ),
            ),
          ),
          Platform.isIOS
              ? CupertinoButton(
                  child: Text("Enviar"),
                  onPressed: _enviarMensagem,
                )
              : FloatingActionButton(
                  backgroundColor: Color(0xff075E54),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  mini: true,
                  onPressed: _enviarMensagem,
                )
        ],
      ),
    );
    var stream = StreamBuilder(
      stream: _controller.stream,
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Carregando sua mensagens"),
                )
              ],
            ));
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar os dados!"),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: querySnapshot.documents.length,
                  // ignore: missing_return
                  itemBuilder: (context, indice) {
                    List<DocumentSnapshot> mensagens =
                        querySnapshot.documents.toList();
                    DocumentSnapshot item = mensagens[indice];

                    double larguraConteiner =
                        MediaQuery.of(context).size.width * 0.8;

                    Alignment alinhamento = Alignment.centerRight;
                    Color cor = Color(0xffd2ffa5);

                    if (_idUsuarioLogado != item["idUsuario"]) {
                      cor = Colors.white;
                      alinhamento = Alignment.centerLeft;
                    }
                    return Align(
                      alignment: alinhamento,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Container(
                          width: larguraConteiner,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: cor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: item["tipo"] == "texto"
                              ? Text(
                                  item["mensagem"],
                                  style: TextStyle(fontSize: 18),
                                )
                              : Image.network(item["urlImagem"]),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            break;
        }
      },
    );

    //app bar
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contato.urlImagem != null
                    ? NetworkImage(widget.contato.urlImagem)
                    : null),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(widget.contato.nome),
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [stream, caixaMensagem],
            ),
          ),
        ),
      ),
    );
  }
}
