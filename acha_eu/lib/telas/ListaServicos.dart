import 'package:acha_eu/model/Categorias.dart';
import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
    var snapshot = await db.collection("usuarios")
        .where("cidade", isEqualTo: cidadeUsuario )
        .where("categoria", isEqualTo: widget.categoria.nome)
        .get();
    for(var item in snapshot.docs){
      Map<String, dynamic> dados = item.data();
      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.descricaoAtividade = dados["descricaoAtividade"];
      usuario.telefone = dados["telefone"];
      usuario.whatsapp = dados["whatsapp"];
      usuario.email = dados["email"];
      usuario.cidade = dados["cidade"];
      usuario.estado = dados["estado"];
      usuario.urlImagem = dados["urlImagem"];
      usuario.descricaoAtividade = dados["descricaoAtividade"];
      usuario.dinheiro = dados["dinheiro"];
      usuario.cheque = dados["cheque"];
      usuario.cartaoCredito = dados["cartaoCredito"];
      usuario.cartaoDebito = dados["cartaoDebito"];
      usuario.pix = dados["pix"];

      _listaContados.add(usuario);
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
                      decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                        padding: EdgeInsets.all(10),
                        child:ListView.builder(
                          itemCount: item.length,
                          // ignore: missing_return
                          itemBuilder: (context, indice) {
                            Usuario dados = item[indice];
                            return Card(
                              color: Color(0xff37474f),
                              child:  ListTile(
                                leading:  CircleAvatar(
                                    maxRadius: 40,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: dados.urlImagem != null
                                        ? NetworkImage(dados.urlImagem)
                                        : null),
                                title: Text(dados.nome,
                                style: TextStyle(
                                  color: Colors.white),),
                                subtitle: Text(dados.descricaoAtividade,
                                  style: TextStyle(
                                      color: Colors.white),),
                                onTap: () {
                                  Navigator.pushNamed(context, "/detalhescontado", arguments: dados);
                                },
                              ),
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
