// ignore_for_file: sort_child_properties_last

import 'package:atendimento/ListaEmpresas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'util/CheckList.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  final TextEditingController _controllerEmpresa = TextEditingController();
  List<Widget> _listaTelas = [
    ListaEmpresas(),
  ];

  void _sair() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    });
  }

  void _cadastrarEmpresa() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Cadastro de empresa"),
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
                      'images/empresa.png',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Digite o nome da empresa"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _controllerEmpresa,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _controllerEmpresa.clear();
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _gravaChekList();
                    _controllerEmpresa.clear();
                  },
                  child: const Text('Confirmar')),
            ],
          );
        });
  }

 
  void _gravaChekList() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    String empresa = _controllerEmpresa.text;
    if (empresa.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('Empresas').doc().set({
          'idUsuario': uid,
          'empresa': empresa,
          'ativo': true,
          'dataAbertura': DateTime.now().toString(),
          'dataFechamento': ''
        }).then((value) {
          CheckListImplantacao checkList = CheckListImplantacao();
          checkList.cadastraCheckList(empresa, uid);
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Image.asset('images/companhia.png'),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          // ignore: prefer_const_constructors
          ListTile(
            leading: const Icon(Icons.history_toggle_off),
            title: const Text("Meus atendimento"),
          ),
          // ignore: prefer_const_constructors
          ListTile(
            leading: const Icon(Icons.history_edu),
            title: const Text("Histórico de atendimento"),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sair"),
            onTap: () {
              _sair();
            },
          ),
        ]),
      ),
      body: _listaTelas[_index],
      floatingActionButton: FloatingActionButton(
          // ignore: prefer_const_constructors
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 28, 30, 146),
          onPressed: (() {
            _cadastrarEmpresa();
          })),
    );
  }
}
