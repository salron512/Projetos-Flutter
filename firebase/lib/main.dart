import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

//firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = "andre.vicensotti@gmail.com";
  String senha = "123456";

/*
 QuerySnapshot querySnapshot = await db.collection("usuarios").getDocuments();
  //print("dados usuarios: " + querySnapshot.documents.toString());
  for(DocumentSnapshot item in querySnapshot.documents){
    var dados = item.documentID;
    var usuario = item.data;
    print(" id usuarios: $dados"
        " ${"nome: " +usuario["nome"]} "
        " ${"idade: " +usuario["idade"].toString()} ");
  }

*/

  /*
  //desloga o usuario
  //auth.signOut();

  //loga o usuario
  auth.signInWithEmailAndPassword(email: email, password: senha
  ).then((firebaseUser){
    print("usuario logado: " + firebaseUser.email);
  }).catchError((erro){
    print("erro");
  });


//verifica se o usuario esta logado
  FirebaseUser usuarioAtual = await auth.currentUser();
  if(usuarioAtual != null){
    print("logado atualmente: " + usuarioAtual.email);
  }else{
    print("deslogado");
  }



  // cria usuario no firebase

  auth.createUserWithEmailAndPassword(email: email, password: senha
  ).then((firebaseUser){
    print("novo usuario cadastrado: " + firebaseUser.email);
  }).catchError((erro){
    print("novo usuario cadastrado erro" + erro.toString());
  });


   // faz filtros para consultado no banco de dados
  QuerySnapshot querySnapshot = await db
      .collection("usuarios")
      //.where("nome", isEqualTo: "André")
      //.where("idade", isLessThan: 30)
      //.where("idade", isGreaterThanOrEqualTo: 20)
      //.orderBy("idade", descending: true)
      //.orderBy("nome", descending: false)
      //.limit(2)
        .where("nome", isGreaterThanOrEqualTo: "m")
      .where("nome", isLessThanOrEqualTo: "m" + "\uf8ff")
      .getDocuments();

  for (DocumentSnapshot item in querySnapshot.documents) {
    var dados = item.data;
    print("filtro nome: ${dados["nome"]}  idade: ${dados["idade"]}");
  }


  // faz consulta no banco de dados a cada alteracao no banco de forma automatica
  db.collection("usuarios").snapshots().listen((snapshot) {
    for (DocumentSnapshot item in snapshot.documents) {
      var dados = item.data;
      print("nome: " +
          dados["nome"].toString() +
          " idade:  " +
          dados["idade"].toString());
    }
  });

//recupera dados do banco de dados
QuerySnapshot querySnapshot = await db.collection("usuarios").getDocuments();
 //print("dados usuarios: " + querySnapshot.documents.toString());
for(DocumentSnapshot item in querySnapshot.documents){
  var dados = item.data;
 print("dados usuarios: " + dados["nome"] + " idade: " + dados["idade"] );
}
*/

//recupera dados do banco de dados
  /*
DocumentSnapshot snapshot = await db.collection("usuarios").document("001").get();
var dados = snapshot.data;
print("dados: " + dados["nome"] + " idade: " + dados["idade"]);
*/

  // deleta registros no banco de dados
//db.collection("usuarios").document("003").delete();

/*
  db.collection("usuarios")
  .document("002")
  .setData({
    "nome" : "Julia",
    "idade": "28"
  });

   DocumentReference ref = await db.collection("noticias")
  .add({
    "titulo" : "Onde de calor em MT",
    "descricao" : "texto exemplo..."
  });
     print("item salvo: " + ref.documentID);

 db.collection("noticias")
  .document("8LqbYLuoBgLibHK49XYK")
  .setData({
   "titulo" : "Onda de Calor em MT - alterada",
   "descricao" : "texto de exemplo"
 });
*/
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _statusUpload = "Upload não iniciado";
  String _urlImagemRecuperada = null;
  File _imagem;

  Future _recuperaImagem(bool daCamera) async {
    File imagemSelecionada;

    if (daCamera) {
      // ignore: deprecated_member_use
      imagemSelecionada =
          await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      // ignore: deprecated_member_use
      imagemSelecionada =
          await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imagem = imagemSelecionada;
    });
  }

  Future _upLoadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("fotos").child("foto1.png");

    StorageUploadTask task = arquivo.putFile(_imagem);

    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _statusUpload = "Em progresso";
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _statusUpload = "Upload realizado com sucesso!";
        });
      }
    });

    task.onComplete.then((snapshot) {
      _recuperaUrlImagem(snapshot);
    });
  }

  Future _recuperaUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Selecionar Imagem"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(_statusUpload),
              RaisedButton(
                child: Text("Camera"),
                onPressed: () {
                  _recuperaImagem(true);
                },
              ),
              RaisedButton(
                child: Text("Galeria"),
                onPressed: () {
                  _recuperaImagem(false);
                },
              ),
              _imagem == null ? Container() : Image.file(_imagem),
              _imagem == null
                  ? Container()
                  : RaisedButton(
                      child: Text("Upload Storage"),
                      onPressed: () {
                        _upLoadImagem();
                      },
                    ),
              _urlImagemRecuperada == null
                  ? Container()
                  : Image.network(_urlImagemRecuperada),
            ],
          ),
        ));
  }
}
