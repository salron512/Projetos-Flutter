import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Modulos extends StatefulWidget {
  Modulos({Key? key}) : super(key: key);

  @override
  State<Modulos> createState() => _ModulosState();
}

class _ModulosState extends State<Modulos> {
  _recuperaModulos() async {
    List listaModulos = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Modulos').get();

    for (var item in snapshot.docs) {
      listaModulos.add(item);
    }
    return listaModulos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Modulos"),
        ),
        body: FutureBuilder(
          future: _recuperaModulos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  // TODO: Handle this case.
                  break;
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  // TODO: Handle this case.
                  break;
                case ConnectionState.done:
                  // TODO: Handle this case.
                  break;
              }
            } else {
              return const Center(
                child: Text("Sem mdulos cadastrado"),
              );
            }
          },
        ));
  }
}
