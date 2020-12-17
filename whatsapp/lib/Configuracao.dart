import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';


class Configuracao extends StatefulWidget {
  @override
  _ConfiguracaoState createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  TextEditingController _controllerNome = TextEditingController();
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagem;

  Future _recuperaImagem(bool daCamera) async {
    File imagemSelecionada;
    if (daCamera) {
      // ignore: deprecated_member_use
      imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      // ignore: deprecated_member_use
      imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async{

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
    .child("perfil")
    .child(_idUsuarioLogado + ".jpg");
   StorageUploadTask task = arquivo.putFile(_imagem);
   task.events.listen((StorageTaskEvent storageTaskEvent) {

     if(storageTaskEvent.type == StorageTaskEventType.progress){

       setState(() {
         _subindoImagem= true;
       });

     }else if(storageTaskEvent.type == StorageTaskEventType.success){
       setState(() {
         _subindoImagem= false;
       });

     }
   });

   //recupera a url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);

    });

  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlIamgemFirestore(url);

    setState(() {
      _urlImagem = url;
    });

  }
  _atualizarNomeFirestore(){
  String nome = _controllerNome.text;
    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome
    };

    Firestore db =  Firestore.instance;
    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);

    Navigator.pushNamed(context, "/home");
  }
  _atualizarUrlIamgemFirestore(String url){

    Map<String, dynamic> dadosAtualizar = {
      "urlImagem" : url
    };

    Firestore db =  Firestore.instance;
      db.collection("usuarios")
    .document(_idUsuarioLogado)
    .updateData(dadosAtualizar);
  }

  _recuperaDadosUsuario() async{

    FirebaseAuth auth =  FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db =  Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
    .document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    _controllerNome.text = dados["nome"];
    print("EMAIL:" + dados["urlImagem"]);

    if(dados["urlImagem"] != null){
     setState(() {
       _urlImagem = dados["urlImagem"];
     });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Center(
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
                _urlImagem != null ?
                NetworkImage(_urlImagem)
                  : null,
                  maxRadius: 100,
                  backgroundColor: Colors.grey),
             Padding(padding: EdgeInsets.all(16),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   FlatButton(
                     child: Text("Câmera",
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: Colors.black
                     ),
                     ),
                     onPressed: (){
                       _recuperaImagem(true);
                     },
                   ),
                   FlatButton(
                     child: Text("Galeria",
                       style: TextStyle(
                           fontSize: 16,
                           fontWeight: FontWeight.bold,
                           color: Colors.black
                       ),
                     ),
                     onPressed: (){
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
