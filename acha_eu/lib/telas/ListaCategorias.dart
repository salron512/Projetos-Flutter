import 'package:acha_eu/model/Categorias.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ListaCategorias extends StatefulWidget {
  @override
  _ListaCategoriasState createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {
  Future _recuperaCategorias() async {
    // ignore: deprecated_member_use
    List<Categorias> listacategoria = List<Categorias>();
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseStorage storage = FirebaseStorage.instance;
    QuerySnapshot snapshot = await db
        .collection("categorias")
        .orderBy("categoria", descending: false)
        .get();
    for (var item in snapshot.docs) {
      Categorias categorias = Categorias();
      Map<String, dynamic> dados = item.data();
      categorias.nome = dados["categoria"];
      categorias.idImagem = dados["idImagem"];
      var imagem = await storage.ref("imagensCategoria/" + categorias.idImagem);
      String url = await imagem.getDownloadURL();
      categorias.urlImagem = url;
      print("categorias: " + categorias.nome);
      print("url: " + categorias.urlImagem);
      listacategoria.add(categorias);
    }
    return listacategoria;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de categorias"),
      ),
      body: Container(
        // ignore: missing_return
        child: FutureBuilder(
            future: _recuperaCategorias(),
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
                  List<Categorias> item = snapshot.data;
                  return Container(
                      decoration: BoxDecoration(color: Colors.blue),
                      padding: EdgeInsets.all(8),
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        children: List.generate(
                            // ignore: missing_return
                            item.length, (index) {
                          var dados = item[index];
                          return Container(
                            width: 100,
                            height: 100,
                            child: GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        maxRadius: 40,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: dados.urlImagem != null
                                            ? NetworkImage(dados.urlImagem)
                                            : null),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(dados.nome),
                                    )
                                  ],
                                )
                            ),
                          );
                        }),
                      ));
                  break;
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

        },
        backgroundColor: Colors.green,
        label: Text("SEJA PROFISSIONAL"),
      ),
    );
  }
}
