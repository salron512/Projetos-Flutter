import 'package:atendimento/util/CheckList.dart';
import 'package:atendimento/util/Participantes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ListaEmpresas extends StatefulWidget {
  ListaEmpresas({Key? key}) : super(key: key);

  @override
  State<ListaEmpresas> createState() => _ListaEmpresasState();
}

class _ListaEmpresasState extends State<ListaEmpresas> {
  final TextEditingController _controllerEmpresa = TextEditingController();
  List _listaChecagem = [];
  late String _uid;

  _alertDelete(String id, empresa) {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirmar exclusão?"),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/excluir.png"),
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
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  DocumentSnapshot snapshot =
                      await FirebaseFirestore.instance.doc(id).get();
                  String idRecuperado = snapshot["idUsuario"];

                  if (idRecuperado == _uid) {
                    CheckListImplantacao check = CheckListImplantacao();
                    check.apagaCheckList(empresa);
                    Participantes participantes = Participantes();
                    participantes.deleteParticipantes(empresa);
                    FirebaseFirestore.instance.doc(id).delete();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    _alertNaoTempermissao();
                  }
                },
                child: const Text("Excluir"),
              ),
            ],
          );
        });
  }

  void _alteraEmpresa(String empresa, id) {
    _controllerEmpresa.text = empresa;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Altera empresa "),
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
                  onPressed: () async {
                    var snapshot = await FirebaseFirestore.instance
                        .collection('Empresas')
                        .where("empresa", isEqualTo: empresa)
                        .get();
                    for (var item in snapshot.docs) {
                      FirebaseFirestore.instance
                          .collection("Empresas")
                          .doc(item.id)
                          .update({'empresa': _controllerEmpresa.text});
                    }

                    CheckListImplantacao check = CheckListImplantacao();
                    check.alteraEmpresa(empresa, _controllerEmpresa.text);
                    Participantes participantes = Participantes();
                    print("participantes " + empresa);
                    participantes.alteraEmpresa(
                        empresa, _controllerEmpresa.text);

                    _alteraEmpresaParticipante(empresa, _controllerEmpresa.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Confirmar')),
            ],
          );
        });
  }

  void _alteraEmpresaParticipante(String empresa, empresaAlterada) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await db
        .collection("Participantes")
        .where('empresa', isEqualTo: empresa)
        .get();

    for (var item in snapshot.docs) {
      db.collection("Participantes").doc(item.id).update({'empresa': empresa});
    }
  }

  _alertNaoTempermissao() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("Sem permissão"),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/negado.png"),
                    ),
                  ),
                  const Text("Você não tem permissão para excluir esse item!")
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        }));
  }

  _veririficaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures
    var usuario = await auth.currentUser;
    _uid = usuario!.uid;
  }

  @override
  void initState() {
    super.initState();
    _veririficaUsuario();
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y H:mm:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Empresas')
              .where('ativo', isEqualTo: true)
              .orderBy("empresa", descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              _listaChecagem = snapshot.data!.docs.toList();
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                          ),
                        ),
                        const Text("sem conexão com o banco de daddos")
                      ],
                    ),
                  );
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.white,
                        )
                      ],
                    ),
                  );
                  break;
                case ConnectionState.active:
                  if (_listaChecagem.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.asset('images/triste.png'),
                            ),
                          ),
                          const Text(
                            "Sem implantações no momento!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        final empresa = snapshot.data!.docs[index];
                        return Slidable(
                          actionPane: const SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: [
                            IconSlideAction(
                                caption: "Editar",
                                color: Colors.green,
                                icon: Icons.edit,
                                onTap: () {
                                  _alteraEmpresa(
                                      empresa['empresa'], empresa.id);
                                }),
                            IconSlideAction(
                              caption: "Excluir",
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                _alertDelete(
                                    empresa.reference.path, empresa['empresa']);
                              },
                            )
                          ],
                          child: Card(
                            child: ListTile(
                              leading: Image.asset('images/comp.png'),
                              // ignore: prefer_interpolation_to_compose_strings
                              title: Text('Empresa: ' + empresa['empresa']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Status: Em execução"),
                                  // ignore: prefer_interpolation_to_compose_strings
                                  Text("Data da abertura: " +
                                      _formatarData(empresa['dataAbertura'])),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, "/modulos",
                                    arguments: empresa['empresa']);
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  }

                  break;
                case ConnectionState.done:
                  return const Center(
                    child: Text("ok"),
                  );
                  break;
              }
              // ignore: prefer_is_empty

            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset('images/triste.png'),
                      ),
                    ),
                    const Text(
                      "Sem implantações no momento!",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
