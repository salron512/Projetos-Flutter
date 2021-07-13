import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Entregadores.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaEntregadores extends StatefulWidget {
  @override
  _ListaEntregadoresState createState() => _ListaEntregadoresState();
}

class _ListaEntregadoresState extends State<ListaEntregadores> {
  Future _recuperaEntregadores() async {
    List<Entegadores> listaEntregadores = [];
    CollectionReference reference =
        FirebaseFirestore.instance.collection('usuarios');

    QuerySnapshot query = await reference
        .orderBy("nome", descending: false)
        .where("tipoUsuario", isEqualTo: "entregador")
        .get();

    for (var item in query.docs) {
      Map<String, dynamic> dados = item.data();
      Entegadores entegadores = Entegadores();
      entegadores.nome = dados["nome"];
      entegadores.telefone = dados["telefone"];
      entegadores.whatsapp = dados["whatsapp"];
      entegadores.endereco = dados["endereco"];
      entegadores.bairro = dados["bairro"];
      entegadores.email = dados["email"];
      entegadores.ativo = dados["ativo"];
      entegadores.uid = dados["idUsuario"];
      listaEntregadores.add(entegadores);
    }
    return listaEntregadores;
  }

  _abrirWhatsApp(String telefone) async {
    var whatsappUrl = "whatsapp://send?phone=+55$telefone=Olá,tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  _abrirTelefone(String telefone) async {
    var telefoneUrl = "tel:$telefone";

    if (await canLaunch(telefoneUrl)) {
      await launch(telefoneUrl);
    } else {
      throw 'Could not launch $telefoneUrl';
    }
  }
/*
  _selecionaOpcao({String telefone, String whatsapp}) {
    // ignore: missing_return
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selecione uma opção"),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Text("")],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _abrirTelefone(telefone);
                  },
                  child: Text("Telefone")),
              TextButton(
                  onPressed: () {
                    _abrirWhatsApp(whatsapp);
                  },
                  child: Text("Telefone")),
            ],
          );
        });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista entregadores"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _recuperaEntregadores(),
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
                if (snapshot.hasData) {
                  List<Entegadores> lista = snapshot.data;
                  return ListView.separated(
                    itemCount: lista.length,
                    separatorBuilder: (context, indice) => Divider(
                      color: Colors.grey,
                      height: 4,
                    ),
                    // ignore: missing_return
                    itemBuilder: (context, indice) {
                      Entegadores entregador = lista[indice];
                      return CheckboxListTile(
                          title: Text(entregador.nome),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Telefone " + entregador.telefone),
                              Text("Whatsapp " + entregador.whatsapp),
                              Text("Endereço " + entregador.endereco),
                              Text("Bairro " + entregador.bairro),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          _abrirTelefone(entregador.telefone);
                                        },
                                        child: Text("Telefone")),
                                    TextButton(
                                        onPressed: () {
                                          _abrirWhatsApp(entregador.whatsapp);
                                        },
                                        child: Text("Whatsapp"))
                                  ],
                                ),
                              )
                            ],
                          ),
                          value: entregador.ativo,
                          onChanged: (value) {
                            FirebaseFirestore.instance
                                .collection("usuarios")
                                .doc(entregador.uid)
                                .update({
                              "ativo": value,
                            });
                            setState(() {
                              entregador.ativo = value;
                            });
                          });
                    },
                  );
                } else {
                  return Center(
                    child: Text("Sem entregadores cadastrados"),
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
