// ignore_for_file: avoid_unnecessary_containers

import 'package:atendimento/model/Modulo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListaCheckList extends StatefulWidget {
  Modulo empresa;
  ListaCheckList(this.empresa);

  @override
  State<ListaCheckList> createState() => _ListaCheckListState();
}

class _ListaCheckListState extends State<ListaCheckList> {
  String _uid = '';
  _recuperaUsario() {
    FirebaseAuth auth = FirebaseAuth.instance;
    _uid = auth.currentUser!.uid;
  }

  @override
  void initState() {
    super.initState();
    _recuperaUsario();
  }

  @override
  Widget build(BuildContext context) {
    String nomeModulo = widget.empresa.nome;
    return Scaffold(
      appBar: AppBar(
        title: Text("Check List: $nomeModulo"),
      ),
      body: Container(
        //decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('CheckList')
              .where('empresa', isEqualTo: widget.empresa.empresa)
              .where("modulo", isEqualTo: widget.empresa.nome)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text("Sem conexão"),
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
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 4,
                      color: Theme.of(context).primaryColor,
                    ),
                    itemBuilder: ((context, index) {
                      final item = snapshot.data!.docs[index];
                      return SafeArea(
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: item['uid'] == _uid
                                    ? Theme.of(context).primaryColor
                                    : Colors.blue,
                                value: item["checado"],
                                onChanged: ((value) {
                                  FirebaseFirestore.instance
                                      .collection("CheckList")
                                      .doc(item.id)
                                      .update({'checado': value, 'uid': _uid});
                                }),
                              ),
                              Text(item["item"]),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                } else {
                  return const Center(
                    child: Text("Sem conexão"),
                  );
                }
                break;
              case ConnectionState.done:
                return const Center(
                  child: Text("Done"),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
