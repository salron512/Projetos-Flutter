import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/Usuario.dart';

class AdmEntregador extends StatefulWidget {
  @override
  _AdmEntregadorState createState() => _AdmEntregadorState();
}

class _AdmEntregadorState extends State<AdmEntregador> {
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
      usuario.entregador = dados["entregador"];
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
        title: Text("Entregador"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: FutureBuilder(
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
                      activeColor: Theme.of(context).primaryColor,
                      value: item.entregador,
                      title: Text(
                        item.nome,
                        style: TextStyle(color: Colors.white),
                      ),
                      onChanged: (value) {
                        FirebaseFirestore db = FirebaseFirestore.instance;
                        db.collection("usuarios").doc(item.senha).update({
                          "entregador": value,
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
      ),
    );
  }
}
