import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Empresa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _deslogar() {
    FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false));
  }

  Future _recuperaEmpresas() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("categorias")
        .orderBy("categoria", descending: false)
        .get();
    FirebaseStorage storage = FirebaseStorage.instance;
    List<Empresa> listaRecuperada = [];

    for (var item in snapshot.docs) {
      Map<String, dynamic> dados = item.data();
      Empresa empresa = Empresa();
      empresa.categoria = dados["categoria"];
      empresa.idImagem = dados["idImagem"];
      var imagem = storage.ref("categorias/" + empresa.idImagem);
      String url = await imagem.getDownloadURL();
      print("url " + url);
      empresa.urlImagem = url;
      listaRecuperada.add(empresa);
    }
    return listaRecuperada;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: _recuperaEmpresas(),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  List list = snapshot.data;
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: list.length,
                    itemBuilder: (context,indice) {
                            Empresa dados = list[indice];
                            return Card(
                              
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 8,
                              child: ListTile(
                                contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                                leading: Image.network(dados.urlImagem),
                                title: Text(dados.categoria),
                              ),
                            );
                          },
                        );
                  } else {
                    return Center(
                        child: Text(
                      "Lista de empresas vazia",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ));
                  }
                  break;
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _deslogar();
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/alteracadastro");
                        }),
                  ],
                ),
              ))),
    );
  }
}
