import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Empresa.dart';
import 'package:flutter/material.dart';

class ListaEmpressas extends StatefulWidget {
  String categoria;
  ListaEmpressas(this.categoria);

  @override
  _ListaEmpressasState createState() => _ListaEmpressasState();
}

class _ListaEmpressasState extends State<ListaEmpressas> {
  Future _recuperaListaEmpresas() async {
    List listaRecuperada = [];
    String categoria = widget.categoria;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("empresas")
        .where("ativa", isEqualTo: true)
        .where("categoria", isEqualTo: categoria)
        .get();
    for (var item in querySnapshot.docs) {
      Map<String, dynamic> dados = item.data();
      Empresa empresa = Empresa();
      empresa.nomeFantasia = dados["nomeFantasia"];
      listaRecuperada.add(empresa);
    }
    return listaRecuperada;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _recuperaListaEmpresas(),
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
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                          title: Text(dadosEmpresa.nomeFantasia,
                          style: TextStyle(
                            color: Colors.white
                          ),
                          ),
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
