import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Empresa.dart';
import 'package:entrega/util/Localizacao.dart';
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
    String cidade = await Localizacao.recuperaLocalizacao();
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
                  return Center(child: Text("Sem opções para essa categoria"));
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
                                  child: Image.network(
                                    dadosEmpresa.urlImagem,
                                    fit: BoxFit.cover,
                                  ),
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
                                  context, "/listaprodutosusuario",
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