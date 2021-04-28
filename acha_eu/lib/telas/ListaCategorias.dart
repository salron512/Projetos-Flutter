import 'package:acha_eu/model/Categorias.dart';
import 'package:acha_eu/util/Localizacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ListaCategorias extends StatefulWidget {
  ListaCategorias({Key key}) : super(key: key);

  @override
  _ListaCategoriasState createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {
  List<String> itensMenu = ["Perfil", "Sair", "Anúncie"];
  bool _mostraMenu = false;

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
      Map<String, dynamic> dados = item.data();
      if (dados["categoria"] == "Cliente") continue;

      Categorias categorias = Categorias();
      categorias.nome = dados["categoria"];
      categorias.idImagem = dados["idImagem"];
      var imagem = storage.ref("imagensCategoria/" + categorias.idImagem);
      String url = await imagem.getDownloadURL();
      categorias.urlImagem = url;
      listacategoria.add(categorias);
    }
    return listacategoria;
    // ignore: dead_code
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Perfil":
        Navigator.pushNamed(context, "/config");
        break;
      case "Sair":
        _deslogarUsuario();
        break;
      case "Anúncie":
        Navigator.pushNamed(context, "/contado");
        break;
    }
  }

  _deslogarUsuario() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut().then((value) {
      setState(() {
        _mostraMenu = false;
      });
    });
  }

  _recuperaUsuario() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    if (user != null) {
      setState(() {
        _mostraMenu = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperaUsuario();
    Localizacao.verificaLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
        actions: [
          IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              }),
          Visibility(
              visible: _mostraMenu,
              child: PopupMenuButton<String>(
                color: Color(0xff37474f),
                onSelected: _escolhaMenuItem,
                // ignore: missing_return
                itemBuilder: (context) {
                  return itensMenu.map((String item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(color: Colors.white)),
                    );
                  }).toList();
                },
              )),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*
           SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
             GestureDetector(
             child:  Padding(
               padding: EdgeInsets.only(left: 10),
               child:  Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     image: DecorationImage(
                         image:  AssetImage("images/teste.png"),
                         fit: BoxFit.cover
                     )
                 ) ,
                 width: 80,
                 height: 80,
               ),
             ),
             onTap: (){
               Navigator.pushNamed(context, "/propaganda");
             },
           ),
             GestureDetector(
             child:  Padding(
               padding: EdgeInsets.only(left: 10),
               child:  Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     image: DecorationImage(
                         image:  AssetImage("images/teste.png"),
                         fit: BoxFit.cover
                     )
                 ) ,
                 width: 80,
                 height: 80,
               ),
             ),
             onTap: (){
               Navigator.pushNamed(context, "/propaganda");
             },
           ),
           GestureDetector(
             child:  Padding(
               padding: EdgeInsets.only(left: 10),
               child:  Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     image: DecorationImage(
                         image:  AssetImage("images/teste.png"),
                         fit: BoxFit.cover
                     )
                 ) ,
                 width: 80,
                 height: 80,
               ),
             ),
             onTap: (){
               Navigator.pushNamed(context, "/propaganda");
             },
           ),
           GestureDetector(
             child:  Padding(
               padding: EdgeInsets.only(left: 10),
               child:  Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     image: DecorationImage(
                         image:  AssetImage("images/teste.png"),
                         fit: BoxFit.cover
                     )
                 ) ,
                 width: 80,
                 height: 80,
               ),
             ),
             onTap: (){
               Navigator.pushNamed(context, "/propaganda");
             },
           ),
           GestureDetector(
             child:  Padding(
               padding: EdgeInsets.only(left: 10),
               child:  Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     image: DecorationImage(
                         image:  AssetImage("images/teste.png"),
                         fit: BoxFit.cover
                     )
                 ) ,
                 width: 80,
                 height: 80,
               ),
             ),
             onTap: (){
               Navigator.pushNamed(context, "/propaganda");
             },
           )
          ]
          ),
          
        ),
        */
          Expanded(
            // decoration: BoxDecoration(color: Color(0xffDCDCDC)),
            // ignore: missing_return
            child: FutureBuilder(
                future: _recuperaCategorias(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Image.asset(
                                "images/conexao.png",
                                width: 250,
                                height: 200,
                              ),
                            ),
                            Text("Sem conexão")
                          ],
                        ),
                      );
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      List<Categorias> item = snapshot.data;
                      return Container(
                          child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        children: List.generate(
                            // ignore: missing_return
                            item.length, (indice) {
                          var dados = item[indice];
                          return Container(
                            padding: EdgeInsets.all(8),
                            width: 100,
                            height: 100,
                            child: GestureDetector(
                              onTap: () async {
                                LocationPermission permission =
                                    await Geolocator.checkPermission();
                                if (permission == LocationPermission.denied ||
                                    permission ==
                                        LocationPermission.deniedForever) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/erro", (route) => false);
                                } else {
                                  Navigator.pushNamed(context, "/listaservicos",
                                      arguments: dados);
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    child: Text(
                                      dados.nome,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ));
                      break;
                  }
                }),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      /*
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, "/listaSolicitacao");
          },
          label: Text("Solicite um profissional")),
      bottomNavigationBar: BottomAppBar(
        color:Color(0xffDCDCDC),
        child:   SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
           GestureDetector(
             child:  Padding(
               padding: EdgeInsets.only(left: 5),
               child:  Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     image: DecorationImage(
                         image:  AssetImage("images/teste.png"),
                         fit: BoxFit.cover
                     )
                 ) ,
                 width: 100,
                 height: 100,
               ),
             ),
             onTap: (){
               Navigator.pushNamed(context, "/propaganda");
             },
           )
          ]
          ),
        )
      ),
      */
    );
  }
}
