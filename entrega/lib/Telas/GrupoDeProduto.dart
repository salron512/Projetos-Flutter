import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GrupoDeProduto extends StatefulWidget {
  @override
  _GrupoDeProdutoState createState() => _GrupoDeProdutoState();
}

class _GrupoDeProdutoState extends State<GrupoDeProduto> {
  StreamController _streamController = StreamController.broadcast();
  TextEditingController _controllerGrupo = TextEditingController();
  TextEditingController _controllerNomeAdicional = TextEditingController();
  TextEditingController _controllerValorAdicional = TextEditingController();

  var _mascaraPreco =
      MaskTextInputFormatter(mask: '########', filter: {"#": RegExp(r'[0-9]')});

  _alertCadastraAdicionais(QueryDocumentSnapshot queryDocumentSnapshot) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Cadastro de adicionais"),
            content: Container(
              width: 250,
              height: 250,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('Insira as informações do adicional'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Digite o nome do adicional" ,
                          //label: Text("Digite o nome do adicional")
                          ),
                      controller: _controllerNomeAdicional,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      
                      inputFormatters: [_mascaraPreco],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefix: Text('R\$ '),
                        labelText: "Digite o preço do adicional",
                          //label: Text("Digite o preço do adicional")
                          ),
                      controller: _controllerValorAdicional,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _recuperaListaGrupoProdutos() {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    CollectionReference reference =
        FirebaseFirestore.instance.collection('grupoProduto');

    reference.where('idEmpresa', isEqualTo: uid).snapshots().listen((event) {
      if (mounted) {
        _streamController.add(event);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaListaGrupoProdutos();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  _excluirGrupo(String idDoc) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Excluir"),
            content: Container(
              height: 150,
              width: 150,
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: Image.asset("images/excluir.png"),
                  ),
                  Text("Confirmar exclusão ?"),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('grupoProduto')
                        .doc(idDoc)
                        .delete()
                        .then((value) => Navigator.pop(context));
                  },
                  child: Text('Confirmar'))
            ],
          );
        });
  }

  _alertEditar(DocumentSnapshot grupo) {
    TextEditingController controllerGrupoEditar =
        TextEditingController(text: grupo["nome"]);

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Editar"),
            content: Container(
              height: 150,
              width: 150,
              child: Column(
                children: [
                  Text("Insira o nome do grupo de produto"),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      controller: controllerGrupoEditar,
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
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    if (controllerGrupoEditar.text.isNotEmpty) {
                      String idDoc = grupo.reference.id;
                      FirebaseFirestore.instance
                          .collection("grupoProduto")
                          .doc(idDoc)
                          .update({'nome': controllerGrupoEditar.text}).then(
                              (value) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text('Cadastrar'))
            ],
          );
        });
  }

  _alertCadastro() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Cadastro"),
            content: Container(
              height: 150,
              width: 150,
              child: Column(
                children: [
                  Text("Insira o nome do grupo de produto"),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      controller: _controllerGrupo,
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
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    if (_controllerGrupo.text.isNotEmpty) {
                      String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
                      FirebaseFirestore.instance
                          .collection("grupoProduto")
                          .doc()
                          .set({
                        'nome': _controllerGrupo.text,
                        'idEmpresa': uid,
                      }).then((value) {
                        Navigator.pop(context);
                        _controllerGrupo.clear();
                      });
                    }
                  },
                  child: Text('Cadastrar'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grupo de produtos"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _streamController.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ));
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot query = snapshot.data;
                if (query.docs.length == 0) {
                  return Center(
                    child: Text("Sem pedidos no momento"),
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, indice) => Divider(
                      height: 4,
                      color: Theme.of(context).primaryColor,
                    ),
                    itemCount: query.docs.length,
                    // ignore: missing_return
                    itemBuilder: (context, indice) {
                      List<QueryDocumentSnapshot> listQuery =
                          query.docs.toList();
                      QueryDocumentSnapshot grupoProduto = listQuery[indice];
                      return ListTile(
                        title: Text(grupoProduto['nome']),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _excluirGrupo(grupoProduto.reference.id);
                                }),
                                 IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  
                                }),
                          ],
                        ),
                        onTap: () => _alertEditar(grupoProduto),
                        onLongPress: () =>
                            _alertCadastraAdicionais(grupoProduto),
                      );
                    },
                  );
                }
                break;
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          _alertCadastro();
        },
      ),
    );
  }
}
