import 'package:acha_eu/model/Categorias.dart';
import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ListaSericos extends StatefulWidget {


  Categorias categoria;
  ListaSericos(this.categoria);
  @override
  _ListaSericosState createState() => _ListaSericosState();
}



class _ListaSericosState extends State<ListaSericos> {
List<Usuario> _listaContados = List();

  Future _recuperaContatos() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String idusuario = await auth.currentUser.uid;
    String cidadeUsuario;
    var dadosUsuario = await db.collection("usuarios").doc(idusuario).get();
    Map<String, dynamic> dados = dadosUsuario.data();
    cidadeUsuario = dados["cidade"];
    print("dados usuario: " + cidadeUsuario);
    print("dados usuario: " + widget.categoria.nome);
    var snapshot = await db.collection("usuarios")
        .where("cidade", isEqualTo: cidadeUsuario )
        .where("categoria", isEqualTo: widget.categoria.nome)
        .get();
    for(var item in snapshot.docs){
      Map<String, dynamic> dados = item.data();
      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.telefone = dados["telefone"];
      usuario.email = dados["email"];
      usuario.cidade = dados["cidade"];
      usuario.estado = dados["estado"];
      usuario.urlImagem = dados["urlImagem"];
      _listaContados.add(usuario);
      print("for: " + usuario.nome);
    }
    return _listaContados;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listaContados.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria.nome),
      ),
        body: FutureBuilder(
            future: _recuperaContatos(),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                List<Usuario> item = snapshot.data;
                  if(item.isEmpty){
                    return Center(
                      child: Text("Sem contado para essa categoria :("),
                    );
                  }else {
                    return Container(
                        decoration: BoxDecoration(color: Colors.blue),
                        padding: EdgeInsets.all(16),
                        child:ListView.separated(
                          itemCount: item.length,
                          separatorBuilder: (context, indice) => Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                          // ignore: missing_return
                          itemBuilder: (context, indice) {
                            Usuario dados = item[indice];
                            return ListTile(
                              leading:  CircleAvatar(
                                  maxRadius: 40,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: dados.urlImagem != null
                                      ? NetworkImage(dados.urlImagem)
                                      : null),
                              title: Text(dados.nome),
                              onTap: () {
                                Navigator.pushNamed(context, "/detalhescontado", arguments: dados);
                              },
                            );
                          },
                        ),
                    );
                  }
                  break;
              }
            }),
    );
  }
}
