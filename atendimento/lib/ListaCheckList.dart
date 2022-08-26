// ignore_for_file: avoid_unnecessary_containers, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'package:atendimento/model/Modulo.dart';
import 'package:atendimento/util/Participantes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// ignore: must_be_immutable
class ListaCheckList extends StatefulWidget {
  Modulo empresa;
  // ignore: use_key_in_widget_constructors
  ListaCheckList(this.empresa);

  @override
  State<ListaCheckList> createState() => _ListaCheckListState();
}

class _ListaCheckListState extends State<ListaCheckList> {
  String _uid = '';
  final TextEditingController _controllerItemCheckList =
      TextEditingController();
  final TextEditingController _controllerItemParticipantes =
      TextEditingController();

  _cadastraItemCheckList() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    FirebaseFirestore.instance.collection("CheckList").doc().set({
      "dataCadastro": DateTime.now().toString(),
      "uid": uid,
      "empresa": widget.empresa.empresa,
      'item': _controllerItemCheckList.text,
      'modulo': widget.empresa.nome,
      'checado': false
    });
    _controllerItemCheckList.clear();
  }

  void _deletaItemCheckList(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Excluir item do checklist"),
            content: SizedBox(
              width: 250,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      'images/excluir.png',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Deseja confirma a exclusão do item?"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection("CheckList")
                        .doc(id)
                        .delete();
                    Navigator.pop(context);
                  },
                  child: const Text('Confirmar')),
            ],
          );
        });
  }

  void _alertCadastraItemCheckList() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Cadastro item do checklist"),
            content: SizedBox(
              width: 250,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      'images/lista.png',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Digite o item do checklist"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _controllerItemCheckList,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _controllerItemCheckList.clear();
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () async {
                    _cadastraItemCheckList();
                    Navigator.pop(context);
                  },
                  child: const Text('Confirmar')),
            ],
          );
        });
  }

  void _validaCadastroParticantes() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Participantes")
        .where("empresa", isEqualTo: widget.empresa.empresa)
        .where("modulo", isEqualTo: widget.empresa.nome)
        .get();

    int i = snapshot.docs.length;
    bool cond = true;
    for (var item in snapshot.docs) {
      cond = false;

      if (i == 0) {
        //Participantes participantes = Participantes();
        // participantes.cadastraParticipantes(widget.empresa.empresa,
        //widget.empresa.nome, _controllerItemParticipantes.text);
        //_controllerItemParticipantes.clear();
        _alertCadastraParticipante();
      } else {
        _controllerItemParticipantes.text = item['colaboradores'];
        _alertAtualizaParticipantes(item.id);
      }
    }

    if (cond) {
      // Participantes participantes = Participantes();
      //participantes.cadastraParticipantes(widget.empresa.empresa,
      //widget.empresa.nome, _controllerItemParticipantes.text);
      // _controllerItemParticipantes.clear();
      _alertCadastraParticipante();
    }

    snapshot.docs.clear();
  }

  void _alertAtualizaParticipantes(String idDoc) {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          content: SizedBox(
            width: 250,
            height: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    'images/atualizar.png',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text('Digite o nome dos participantes'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _controllerItemParticipantes,
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              // ignore: prefer_const_constructors
              child: Text("Cancelar"),
              onPressed: (() {
                Navigator.pop(context);
                _controllerItemParticipantes.clear();
              }),
            ),
            TextButton(
              // ignore: prefer_const_constructors
              child: Text("Confirma"),
              onPressed: (() {
                FirebaseFirestore.instance
                    .collection("Participantes")
                    .doc(idDoc)
                    .update(
                        {'colaboradores': _controllerItemParticipantes.text});
                Navigator.pop(context);
                _controllerItemParticipantes.clear();
              }),
            ),
          ],
        );
      }),
    );
  }

  void _alertCadastraParticipante() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Cadastro participantes"),
            content: SizedBox(
              width: 250,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      'images/equipe.png',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Digite o nome dos participantes"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _controllerItemParticipantes,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _controllerItemParticipantes.clear();
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () async {
                    Participantes participantes = Participantes();
                    participantes.cadastraParticipantes(widget.empresa.empresa,
                        widget.empresa.nome, _controllerItemParticipantes.text);
                    _controllerItemParticipantes.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Confirmar')),
            ],
          );
        });
  }

  void _recuperaUsario() {
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
        padding: const EdgeInsets.only(left: 5, right: 5),
        //decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('CheckList')
              .where('empresa', isEqualTo: widget.empresa.empresa)
              .where("modulo", isEqualTo: widget.empresa.nome)
              .orderBy('item', descending: false)
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

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                                child: CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    item["item"],
                                  ),
                                  activeColor: item['uid'] == _uid
                                      ? Theme.of(context).primaryColor
                                      : Colors.blue,
                                  value: item["checado"],
                                  onChanged: ((value) {
                                    FirebaseFirestore.instance
                                        .collection("CheckList")
                                        .doc(item.id)
                                        .update(
                                            {'checado': value, 'uid': _uid});
                                  }),
                                ),
                                onLongPress: () {
                                  _deletaItemCheckList(item.id);
                                }),
                          ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SpeedDial(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icons.add,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.people_alt,
              color: Colors.white,
            ),
            label: "Cadastrar participantes",
            backgroundColor: Colors.amber,
            onTap: () {
              //_alertCadastraParticipante();
              _validaCadastroParticantes();
            },
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.pending_actions_outlined,
              color: Colors.white,
            ),
            label: "Cadastrar observação",
            backgroundColor: Colors.cyan,
            onTap: () {},
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.app_registration_outlined,
              color: Colors.white,
            ),
            backgroundColor: Colors.deepOrange,
            label: "Cadastrar item do checklist",
            onTap: () {
              _alertCadastraItemCheckList();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 150,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Participantes")
                  .where("empresa", isEqualTo: widget.empresa.empresa)
                  .where('modulo', isEqualTo: widget.empresa.nome)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                      child: Text("sem conexão"),
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
                    List listadados = snapshot.data!.docs;
                    if (listadados.length == 0) {
                      return const Center(
                        child: Text("Sem informações cadastrads"),
                      );
                    } else {
                      DocumentSnapshot snapshot = listadados[0];
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Participantes: ' + snapshot['colaboradores'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Obervação: ' + snapshot['observacao'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    break;
                  case ConnectionState.done:
                    return const Center(
                      child: Text("ok"),
                    );
                    break;
                }
              }),
        ),
      ),
    );
  }
}
