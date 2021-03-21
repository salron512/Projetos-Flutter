import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Adm extends StatefulWidget {
  @override
  _AdmState createState() => _AdmState();
}

class _AdmState extends State<Adm> {

  Future _recuperaDadosUsuario() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot snapshots = await db.collection("usuarios").get();
    List<Usuario> listaDados = List();
    for (var item in snapshots.docs){
      Map<String, dynamic> dados = item.data();
      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.idUsuario = dados["idUsuario"];
      usuario.telefone = dados["telefone"];
      usuario.categoriaUsuario = dados["categoriaUsuario"];
      usuario.mostraPagamento = dados["mostraPagamento"];
      listaDados.add(usuario);
    }
    return listaDados;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _recuperaDadosUsuario(),
          // ignore: missing_return
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if(snapshot.hasError){
                  return Center(
                    child: Text("Sem usuarios no momento"),
                  );
                }else{
                  List<Usuario> listaUsuario = snapshot.data;
                  ListView.builder(
                    itemCount: listaUsuario.length ,
                    // ignore: missing_return
                    itemBuilder: (context, indice){
                      var item = listaUsuario[indice];
                      return ListTile(
                        title: Text("nome: " + item.nome),
                        subtitle: Text("nome: " + item.telefone) ,
                      );
                    },
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
