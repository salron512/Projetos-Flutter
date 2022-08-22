// ignore_for_file: non_constant_identifier_names

import 'package:atendimento/model/Modulo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Modulos extends StatefulWidget {
  String empresa;
  Modulos(this.empresa);

  @override
  State<Modulos> createState() => _ModulosState();
}

class _ModulosState extends State<Modulos> {
  Future<List<Modulo>> _retuperaModulos() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Modulos')
        .orderBy("nome", descending: false)
        .get();
    List<Modulo> listaRecuperada = [];

    for (var item in snapshot.docs) {
      Modulo modulo = Modulo();
      modulo.nome = item['nome'];

      modulo.url = item['Url'];
      // ignore: prefer_interpolation_to_compose_strings
      Reference imagem = storage.ref('Modulos/' + modulo.url);
      modulo.urlImagem = await imagem.getDownloadURL();
      listaRecuperada.add(modulo);
    }

    return listaRecuperada;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Modulos"),
        ),
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: FutureBuilder(
            future: _retuperaModulos(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Modulo>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(
                    child: Text("Sem Conexão"),
                  );
                  break;
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                  break;
                case ConnectionState.active:
                  return const Center(
                    child: Text("Active"),
                  );
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<Modulo>? Listamodulos = snapshot.data;
                    return GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        children: List.generate(Listamodulos!.length, ((index) {
                          Modulo item = Listamodulos[index];
                          item.empresa = widget.empresa;
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                                decoration: BoxDecoration(
                                  // ignore: prefer_const_literals_to_create_immutables

                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),

                                // ignore: prefer_interpolation_to_compose_strings
                                child: GestureDetector(
                                  onTap: (() {
                                    Navigator.pushNamed(
                                        context, "/checkList",
                                        arguments: item);
                                  }),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Image.network(item.urlImagem),
                                      ),
                                      Text(item.nome),
                                    ],
                                  ),
                                )),
                          );
                        })));
                  } else {
                    return const Center(
                      child: Text(
                        "Sem dados cadastrados",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  break;
              }
            },
          ),
        ));
  }
}
