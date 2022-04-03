import 'package:acha_eu/model/Categorias.dart';
import 'package:acha_eu/model/Usuario.dart';
import 'package:acha_eu/util/Localizacao.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListaSericos extends StatefulWidget {
  Categorias categoria;
  ListaSericos(this.categoria);
  @override
  _ListaSericosState createState() => _ListaSericosState();
}

class _ListaSericosState extends State<ListaSericos> {
  List<Usuario> _listaContados = [];
  String _categoria;

  Future _recuperaContatos() async {
    //recupera a lista de pofissionais pela categoria e cidade
    //

    String cidadeUsuario;
    _categoria = widget.categoria.nome;

    cidadeUsuario = await Localizacao.recuperaLocalizacao();
    FirebaseFirestore db = FirebaseFirestore.instance;
    print("cidade teste " + cidadeUsuario);

    var snapshot = await db
        .collection("usuarios")
        .where("cidade", isEqualTo: cidadeUsuario)
        .where("categoria", isEqualTo: widget.categoria.nome)
        .get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> dados = item.data();
      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.descricaoAtividade = dados["descricaoAtividade"];
      usuario.telefone = dados["telefone"];
      usuario.whatsapp = dados["whatsapp"];
      usuario.descricao = dados["descricao"];
      usuario.email = dados["email"];
      usuario.cidade = dados["cidade"];
      usuario.estado = dados["estado"];
      usuario.urlImagem = dados["urlImagem"];
      usuario.descricaoAtividade = dados["descricaoAtividade"];
      usuario.dinheiro = dados["dinheiro"];
      usuario.cheque = dados["cheque"];
      usuario.cartaoCredito = dados["cartaoCredito"];
      usuario.cartaoDebito = dados["cartaoDebito"];
      usuario.pix = dados["pix"];
      _listaContados.add(usuario);
    }
    return _listaContados;
  }

  @override
  void dispose() {
    super.dispose();
    _listaContados.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria.nome),
      ),
      body: FutureBuilder(
          future: _recuperaContatos(),
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
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sem contatos para essa categoria :(",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: ElevatedButton(
                            child: Text(
                              "Indique alguém",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff37474f),
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/sugestaoUsuario",
                                  arguments: _categoria);
                            },
                          ),
                        ),
                      )
                    ],
                  ));
                } else {
                  return Container(
                    // decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: item.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        Usuario dados = item[indice];
                        return Card(
                          color: Color(0xff37474f),
                          child: ListTile(
                            leading: CircleAvatar(
                               
                                backgroundColor: Colors.grey,
                                backgroundImage: dados.urlImagem != null
                                    ? CachedNetworkImageProvider(
                                        dados.urlImagem,
                                      )
                                    : null),
                            title: Text(
                              dados.nome,
                              style: TextStyle(color: Color(0xffDCDCDC)),
                            ),
                            subtitle: dados.descricao == null
                                ? Text(" ")
                                : Text(
                                    dados.descricao,
                                    style: TextStyle(color: Colors.white),
                                  ),
                            onTap: () {
                              Navigator.pushNamed(context, "/detalhescontado",
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
