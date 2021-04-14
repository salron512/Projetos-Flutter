import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/Usuario.dart';



class Adm extends StatefulWidget {
  @override
  _AdmState createState() => _AdmState();
}

class _AdmState extends State<Adm> {
  Future _recuperaUsuarios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Usuario> list = [];
    var snapshot = await db
        .collection("usuarios")
        .orderBy("nome", descending: false)
        .get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> dados = item.data();
      Usuario usuario = Usuario();
      if(dados["nome"] == "adm")continue;
      usuario.adm = dados["adm"];
      usuario.nome = dados["nome"];
      usuario.senha = dados["idUsuario"];
      list.add(usuario);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("lista usuário"),
      ),
      body: FutureBuilder(
          future: _recuperaUsuarios(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Usuario> dados = snapshot.data;
              return ListView.builder(
                itemCount: dados.length,
                // ignore: missing_return
                itemBuilder: (context, indice) {
                  var item = dados[indice];
                  return CheckboxListTile(
                    value: item.adm,
                    title: Text(item.nome),
                    onChanged: (value) {
                      FirebaseFirestore db = FirebaseFirestore.instance;
                      db.collection("usuarios").doc(item.senha).update({
                        "adm": value,
                      });
                      setState(() {
                        item.adm = value;
                      });
                    },
                  );
                },
              );
            }
          }),
    );
  }
}
