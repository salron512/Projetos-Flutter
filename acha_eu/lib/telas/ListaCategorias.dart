import 'package:acha_eu/model/Categorias.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ListaCategorias extends StatefulWidget {
  @override
  _ListaCategoriasState createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {
  List<String> itensMenu = ["Perfil", "Deslogar", "Anúncie"];

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
      //print("categorias: " + categorias.nome);
      //print("url: " + categorias.urlImagem);
      listacategoria.add(categorias);
    }
    return listacategoria;
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Perfil":
        Navigator.pushNamed(context, "/config");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Anúncie":
        Navigator.pushNamed(context, "/contado");
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  recebeNot() {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      // será chamado sempre que uma notificação for aberta / botão pressionado.
      if (result != null) {
        FirebaseFirestore db = FirebaseFirestore.instance;
        FirebaseAuth auth = FirebaseAuth.instance;
        String id = auth.currentUser.uid;
        var dados = await db.collection("usuarios").doc(id).get();
        Map<String, dynamic> map = dados.data();
        String categoria = map["categoria"];
        print("teste ok!");
        Navigator.pushNamed(context, "/listaPedidos", arguments: categoria);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    recebeNot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
        actions: [
          PopupMenuButton<String>(
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
          )
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
                              onTap: () {
                                Navigator.pushNamed(context, "/listaservicos",
                                    arguments: dados);
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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, "/listaSolicitacao");
          },
          label: Text("Solicite um profissional")),
      /*
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
