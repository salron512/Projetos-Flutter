import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/Conversa.dart';
import 'model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {

  String _idUsuarioLogado;
  String _emailsuarioLogado;

  _recuperaDadosUsuario() async{

    FirebaseAuth auth =  FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    _emailsuarioLogado = usuarioLogado.email;

  }


  Future<List<Usuario>> _recuperaContatos() async {
    Firestore db = Firestore.instance;
    QuerySnapshot snapshot = await db.collection("usuarios").getDocuments();
    List<Usuario> listaUsuarios = List();
    for (DocumentSnapshot item in snapshot.documents) {
      var dados = item.data;
      if(dados["email"] == _emailsuarioLogado ) continue;

      Usuario usuario = Usuario();
      usuario.email = dados["email"];
      usuario.nome = dados["nome"];
      usuario.urlImagem = dados["urlImagem"];

      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
        future: _recuperaContatos(),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Column(
                   mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                   CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.all(8),
                      child:  Text("Carregando contatos") ,
                  )
                ],
              ));
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  // ignore: missing_return
                  itemBuilder: (_, indice) {
                    // ignore: missing_return
                    List<Usuario> listaItens = snapshot.data;
                    Usuario usuario = listaItens[indice];

                    return ListTile(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: usuario.urlImagem != null
                              ? NetworkImage(usuario.urlImagem)
                              : null),
                      title: Text(
                        usuario.nome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    );
                  });
              break;
          }
        });
  }
}
