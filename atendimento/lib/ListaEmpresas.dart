// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaEmpresas extends StatefulWidget {
  ListaEmpresas({Key? key}) : super(key: key);

  @override
  State<ListaEmpresas> createState() => _ListaEmpresasState();
}

class _ListaEmpresasState extends State<ListaEmpresas> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Empresas')
            .where('ativo', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> children;
          if (snapshot.hasError) {
            children = <Widget>[
              const Center(
                child: Text(
                  'Sem implantações no momento :(',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ];
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                children = const <Widget>[
                  Text("nada")
                ];
                break;
              case ConnectionState.waiting:
                children = const <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ];
                break;
              case ConnectionState.active:
                children = <Widget>[];
                break;
              case ConnectionState.done:
                children = <Widget>[
                  
                  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        //List lista =snapshot.data!.docs.toList();
                        DocumentSnapshot empresa = snapshot.data!.docs[index];

                        return Card(
                          child: ListTile(
                            title: Text(empresa["empresa"]),
                          ),
                        );
                      }))
                ];
                break;
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
        },
      ),
    );
  }
}
