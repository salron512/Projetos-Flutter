import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:projeto_tiago/util/Localizacao.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';

class ListaCategorias extends StatefulWidget {
  @override
  _ListaCategoriasState createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {
  StreamController _streamController = StreamController.broadcast();
  bool _adm = false;
  bool _entregador = false;
  String _nome = "";

  _recuperaListaCategorias() {
    CollectionReference stream =
        FirebaseFirestore.instance.collection("categorias");

    stream.orderBy("categoria", descending: false).snapshots().listen((event) {
      if (mounted) {
        _streamController.add(event);
      }
    });
  }

  _recuperaUsuario() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String idUsuario = RecuperaDadosFirebase.RECUPERAUSUARIO();
    var snap = await db.collection("usuarios").doc(idUsuario).get();
    Map<String, dynamic> dados = snap.data();
    setState(() {
      _nome = dados["nome"];
      _adm = dados["adm"];
      _entregador = dados["entregador"];
    });
    if (_adm) {
      setState(() {
        _entregador = true;
      });
    }
  }

  _deslogar() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((value) =>
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false));
  }

  _recebeNot() {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      // será chamado sempre que uma notificação for aberta / botão pressionado.
      // sempre que o content da notificação for aterado é necessario alterar o
      // o switch
      if (result != null) {
        String dados = result.notification.payload.body;

        print("ok " + dados);
        switch (dados) {
          case "Você tem uma nova solicitação de orçamento!":
            Navigator.pushNamed(context, "/listaorcamento");
            break;

          case "Você tem uma nova entrega!":
            Navigator.pushNamed(context, "/listapedidos");
            break;

          case "Sua entrega já foi enviada!":
            Navigator.pushNamed(context, "/pedidousuario");
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
     _recuperaUsuario();
    _recebeNot();
    _recuperaListaCategorias();
    Localizacao.verificaLocalizacao();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catálogo"),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.asset("images/usericon.png"),
                    ),
                    Text(
                      _nome,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.people_alt),
                title: Text('Cadastro Adm'),
                onTap: () {
                  Navigator.pushNamed(context, "/adm");
                },
              ),
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.work_outline),
                title: Text('Cadastro entregador'),
                onTap: () {
                  Navigator.pushNamed(context, "/entregador");
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text("Alterar cadastro"),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SegundaTela()));
                setState(() {
                  Navigator.pushNamed(context, "/config");
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text("Carrinho de compras"),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SegundaTela()));
                setState(() {
                  Navigator.pushNamed(context, "/listaCompras");
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.access_alarms_outlined),
              title: Text("Pedidos em andamento"),
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, "/pedidousuario");
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.engineering),
              title: Text("Solicitar reparo"),
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, "/reparo");
                });
              },
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('Cadastro de produtos'),
                onTap: () {
                  Navigator.pushNamed(context, "/produtos");
                },
              ),
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.add_circle),
                title: Text('Cadastro de categorias'),
                onTap: () {
                  Navigator.pushNamed(context, "/categoria");
                },
              ),
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.miscellaneous_services),
                title: Text("Lista serviços"),
                onTap: () {
                  Navigator.pushNamed(context, "/listaorcamento");
                },
              ),
            ),
            Visibility(
              visible: _entregador,
              child: ListTile(
                leading: Icon(Icons.update),
                title: Text('Pedidos pendentes'),
                onTap: () {
                  Navigator.pushNamed(context, "/listapedidos");
                },
              ),
            ),
            Visibility(
              visible: _entregador,
              child: ListTile(
                leading: Icon(Icons.delivery_dining),
                title: Text('Entregas em andamento'),
                onTap: () {
                  Navigator.pushNamed(context, "/listaentregas",
                      arguments: _adm);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Minhas compras'),
              onTap: () {
                Navigator.pushNamed(context, "/minhasentregas");
              },
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.assignment_outlined),
                title: Text('Histórico'),
                onTap: () {
                  Navigator.pushNamed(context, "/historico");
                },
              ),
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Reparos finalizados'),
                onTap: () {
                  Navigator.pushNamed(context, "/listaservicosfinal");
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                _deslogar();
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: StreamBuilder(
          stream: _streamController.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot querySnapshot = snapshot.data;
                if (querySnapshot.docs.length == 0) {
                  return Center(
                    child: Text(
                      "Sem categorias cadastradas",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                } else {
                  return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    children: List.generate(
                        // ignore: missing_return
                        querySnapshot.docs.length, (indice) {
                      List<DocumentSnapshot> urls = querySnapshot.docs.toList();
                      DocumentSnapshot dados = urls[indice];
                      // ignore: missing_required_param
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/carrinho",
                              arguments: dados["categoria"]);
                        },
                        child: PhysicalModel(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.white,
                          elevation: 8,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 60,
                                  child: dados["urlImagem"] == null
                                      ? Center(
                                          child:
                                              Image.asset("images/error.png"),
                                        )
                                      : Image.network(
                                          dados["urlImagem"],
                                        ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Text(
                                          dados["categoria"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
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
