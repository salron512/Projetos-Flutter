import 'package:acha_eu/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Adm extends StatefulWidget {
  @override
  _AdmState createState() => _AdmState();
}

class _AdmState extends State<Adm> {
  List<String> itensMenu = ["Sugestões"];
  List<String> _listaEstado = ["MT"];
  List<String> _listaCidades;
  String _scolhaEstado;
  String _escolhaCidade = "";


  Future _recuperaDadosUsuario() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Usuario> listaDados = [];
    if (_escolhaCidade == "") {
      QuerySnapshot snapshots = await db
          .collection("usuarios")
          .orderBy("nome", descending: false)
          .get();
      for (var item in snapshots.docs) {
        Map<String, dynamic> dados = item.data();
        Usuario usuario = Usuario();
        usuario.nome = dados["nome"];
        usuario.idUsuario = dados["idUsuario"];
        usuario.telefone = dados["telefone"];
        usuario.whatsapp = dados["whatsapp"];
        usuario.adm = dados["adm"];
        usuario.categoriaUsuario = dados["categoria"];
        usuario.mostraPagamento = dados["mostraPagamento"];
        usuario.estado = dados["estado"];
        usuario.cidade = dados["cidade"];
        usuario.idUsuario = dados["idUsuario"];
        usuario.email = dados["email"];
        listaDados.add(usuario);
      }
      //return listaDados;
    } else {
      print("escolha cidade" + _escolhaCidade);
      QuerySnapshot snapshots = await db
          .collection("usuarios")
          .orderBy("nome", descending: false)
          .get();
      for (var item in snapshots.docs) {
        Map<String, dynamic> dados = item.data();
        if (dados["cidade"] != _escolhaCidade) continue;
        Usuario usuario = Usuario();
        usuario.nome = dados["nome"];
        usuario.idUsuario = dados["idUsuario"];
        usuario.telefone = dados["telefone"];
        usuario.whatsapp = dados["whatsapp"];
        usuario.adm = dados["adm"];
        usuario.categoriaUsuario = dados["categoria"];
        usuario.mostraPagamento = dados["mostraPagamento"];
        usuario.estado = dados["estado"];
        usuario.cidade = dados["cidade"];
        usuario.idUsuario = dados["idUsuario"];
        usuario.email = dados["email"];
        listaDados.add(usuario);
      }
    }
    print("lista retornada");
    return listaDados;
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Sugestões":
        Navigator.pushNamed(context, "/listaSugestao");
        break;
    }
  }

  _recuperaListaCidades() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var dados = await db
        .collection("cidades")
        .where("estado", isEqualTo: _scolhaEstado)
        .get();

    List<String> listaCidadesRecuperadas = [];
    for (var item in dados.docs) {
      var dados = item.data();
      listaCidadesRecuperadas.add(dados["cidade"]);
    }
    setState(() {
      _listaCidades = listaCidadesRecuperadas;
    });
    _mostraListaCidade();
  }

  _mostraListaCidade() {
    if (_listaCidades.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Cidade"),
              content: Container(
                width: 100,
                height: 250,
                child: ListView.separated(
                  itemCount: _listaCidades.length,
                  separatorBuilder: (context, indice) => Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  // ignore: missing_return
                  itemBuilder: (context, indice) {
                    String item = _listaCidades[indice];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        // _recuperaListaCidades();
                        setState(() {
                          _escolhaCidade = item;
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
              ],
            );
          });
    } else {}
  }

  _mostraListaEstado() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Estado"),
            content: Container(
              width: 100,
              height: 250,
              child: ListView.separated(
                itemCount: _listaEstado.length,
                separatorBuilder: (context, indice) => Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                // ignore: missing_return
                itemBuilder: (context, indice) {
                  String item = _listaEstado[indice];
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      _scolhaEstado = item;
                      // _listaCidades.clear();
                      Navigator.pop(context);
                      _recuperaListaCidades();
                    },
                  );
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de usuarios"),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: IconButton(
              icon: Icon(Icons.add_location_outlined, color: Colors.white),
              onPressed: () {
                _mostraListaEstado();
              },
            ),
          ),
          PopupMenuButton<String>(
            color: Color(0xff37474f),
            onSelected: _escolhaMenuItem,
            // ignore: missing_return
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(color: Colors.white)),
                );
              }).toList();
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _recuperaDadosUsuario(),
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                List<Usuario> item = snapshot.data;
                if (item.isEmpty) {
                  return Center(
                    child: Text("Sem usuarios cadastrados :("),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: item.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        Usuario dados = item[indice];
                        return Card(
                          color: Color(0xff37474f),
                          child: ListTile(
                            title: Text(
                              dados.nome,
                              style: TextStyle(color: Color(0xffDCDCDC)),
                            ),
                            subtitle: dados.mostraPagamento == true
                                ? Text(
                                    "Anunciante",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "Não anunciante",
                                    style: TextStyle(color: Colors.white),
                                  ),
                            onTap: () {
                              Navigator.pushNamed(context, "/detalhesAdm",
                                  arguments: dados);
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                break;
            }
          }),
    );
  }
}
