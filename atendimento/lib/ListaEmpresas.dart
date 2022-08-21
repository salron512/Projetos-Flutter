// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_null_comparison

import 'dart:async';
import 'package:atendimento/util/CheckList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ListaEmpresas extends StatefulWidget {
  ListaEmpresas({Key? key}) : super(key: key);

  @override
  State<ListaEmpresas> createState() => _ListaEmpresasState();
}

class _ListaEmpresasState extends State<ListaEmpresas> {
  List _listaChecagem = [];

  _alertDelete(String id, empresa) {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar exclusão?"),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/excluir.png"),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  print("EMPRESA $empresa");
                  CheckListImplantacao check = CheckListImplantacao();
                  check.apagaCheckList(empresa);
                  FirebaseFirestore.instance.doc(id).delete();
                  Navigator.pop(context);
                },
                child: Text("Excluir"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Empresas')
              .where('ativo', isEqualTo: true)
              .orderBy("empresa", descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              _listaChecagem = snapshot.data!.docs.toList();
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                          ),
                        ),
                        const Text("sem conexão com o banco de daddos")
                      ],
                    ),
                  );
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.white,
                        )
                      ],
                    ),
                  );
                  break;
                case ConnectionState.active:
                  if (_listaChecagem.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.asset('images/triste.png'),
                            ),
                          ),
                          const Text(
                            "Sem implantações no momento!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        final empresa = snapshot.data!.docs[index];
                        return Dismissible(
                          onDismissed: (direcao) {
                            _alertDelete(
                                empresa.reference.path, empresa['empresa']);
                          },
                          key: Key(
                              DateTime.now().millisecondsSinceEpoch.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                          child: Card(
                            child: ListTile(
                              leading: Image.asset('images/comp.png'),
                              // ignore: prefer_interpolation_to_compose_strings
                              title: Text('Empresa: ' + empresa['empresa']),
                              subtitle: Text("Status: Em execução"),
                              onTap: () {
                                Navigator.pushNamed(context, "/modulos",
                                    arguments: empresa['empresa']);
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  }

                  break;
                case ConnectionState.done:
                  return Center(
                    child: Text("ok"),
                  );
                  break;
              }
              // ignore: prefer_is_empty

            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset('images/triste.png'),
                      ),
                    ),
                    const Text(
                      "sem implantações no momento!",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
