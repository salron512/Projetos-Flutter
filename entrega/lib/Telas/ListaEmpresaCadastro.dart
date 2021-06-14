import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Empresa.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaEmpresaCadastro extends StatefulWidget {
  @override
  _ListaEmpresaCadastroState createState() => _ListaEmpresaCadastroState();
}

class _ListaEmpresaCadastroState extends State<ListaEmpresaCadastro> {
  Future _recuperaListaEmpresas() async {
    List listaRecuperada = [];

    CollectionReference reference =
        FirebaseFirestore.instance.collection("usuarios");

    QuerySnapshot querySnapshot = await reference
        .orderBy("aberto", descending: true)
        .where("tipoUsuario", isEqualTo: "empresa")
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
      empresa.ativo = dados["ativa"];
      empresa.telefone = dados["telefone"];
      listaRecuperada.add(empresa);
    }
    return listaRecuperada;
  }
   _abrirTelefone(String telefone) async {
    var telefoneUrl = "tel:$telefone";

    if (await canLaunch(telefoneUrl)) {
      await launch(telefoneUrl);
    } else {
      throw 'Could not launch $telefoneUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _recuperaListaEmpresas(),
          // ignore: missing_return
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
                      return CheckboxListTile(
                          title: Text(dadosEmpresa.nomeFantasia),
                          subtitle: Column(
                            children: [
                              Text(dadosEmpresa.idEmpresa),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        _abrirTelefone(dadosEmpresa.telefone);
                                      },
                                      child: Text("Telefone")),
                                ],
                              ),
                            ],
                          ),
                          value: dadosEmpresa.ativo,
                          onChanged: (value) {
                            FirebaseFirestore.instance
                                .collection("usuarios")
                                .doc(dadosEmpresa.idEmpresa)
                                .update({
                              "ativa": value,
                            });
                            setState(() {
                              dadosEmpresa.ativo = value;
                            });
                          });
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
