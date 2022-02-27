import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Empresa.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListaEmpressas extends StatefulWidget {
  String categoria;
  ListaEmpressas(this.categoria);

  @override
  _ListaEmpressasState createState() => _ListaEmpressasState();
}

class _ListaEmpressasState extends State<ListaEmpressas> {
  Future _recuperaListaEmpresas() async {
    //String cidade = await Localizacao.recuperaLocalizacao();
    String cidade = '';
    String idDocumento = RecuperaFirebase.RECUPERAIDUSUARIO();
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(idDocumento)
        .get();
    Map<String, dynamic> mapUsuario = doc.data();
    cidade = mapUsuario['cidade'];
    print(cidade);

    List listaRecuperada = [];

    String categoria = widget.categoria;
    CollectionReference reference =
        FirebaseFirestore.instance.collection("usuarios");

    QuerySnapshot querySnapshot = await reference
        .orderBy("aberto", descending: true)
        .where("cidade", isEqualTo: cidade)
        .where("tipoUsuario", isEqualTo: "empresa")
        .where("ativa", isEqualTo: true)
        .where("categoria", isEqualTo: categoria)
        .get();

    for (var item in querySnapshot.docs) {
      Map<String, dynamic> dados = item.data();
      Empresa empresa = Empresa();
      empresa.nomeFantasia = dados["nomeFantasia"];
      empresa.urlImagem = dados["urlImagem"];
      empresa.hAbertura = dados["hAbertura"];
      empresa.hFechamento = dados["hFechamento"];
      empresa.diasFunc = dados["diasFunc"];
      empresa.idEmpresa = dados["idEmpresa"];
      empresa.estado = dados["aberto"];
      listaRecuperada.add(empresa);
    }
    return listaRecuperada;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de opções"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _recuperaListaEmpresas(),
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                List listaSnap = snapshot.data;
                if (listaSnap.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sem opções para essa categoria"),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          child: Text(
                            "Indique uma empresa",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/indicacaoEmpresa');
                          },
                        ),
                      )
                    ],
                  ));
                } else {
                  return ListView.builder(
                    itemCount: listaSnap.length,
                    // ignore: missing_return
                    itemBuilder: (context, indice) {
                      Empresa dadosEmpresa = listaSnap[indice];
                      return Card(
                        elevation: 8,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(20, 16, 5, 16),
                          leading: dadosEmpresa.urlImagem == null
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(
                                    "images/error.png",
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  child: CachedNetworkImage(imageUrl: dadosEmpresa.urlImagem,
                                  fit:  BoxFit.cover,
                                  ), 
                                  /*
                                  Image.network(
                                    dadosEmpresa.urlImagem,
                                    fit: BoxFit.cover,
                                  ),

                                ),
                                */
                              ),
                          title: Text(
                            dadosEmpresa.nomeFantasia,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Aberto de: " + dadosEmpresa.diasFunc,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Horário de funcionamento ${dadosEmpresa.hAbertura} á ${dadosEmpresa.hFechamento} ",
                                style: TextStyle(color: Colors.white),
                              ),
                              dadosEmpresa.estado == true
                                  ? Text("Aberto",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green))
                                  : Text("Fechado",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey)),
                            ],
                          ),
                          onTap: () {
                            if (dadosEmpresa.estado) {
                              Navigator.pushNamed(
                                  context, "/listagrupoprodutosusuario",
                                  arguments: dadosEmpresa.idEmpresa);
                            }
                          },
                        ),
                      );
                    },
                  );
                }
                break;
            }
          },
        ),
      ),
    );
  }
}
