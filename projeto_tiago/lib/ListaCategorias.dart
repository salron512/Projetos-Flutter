import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListaCategorias extends StatefulWidget {
  @override
  _ListaCategoriasState createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {
  StreamController _streamController = StreamController.broadcast();
  bool _adm = false;
  String _nome ="";

  _recuperaListaCategorias() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("categorias").snapshots().listen((event) {
      _streamController.add(event);
    });
  }

  _recuperaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String idUsuario = auth.currentUser.uid;
    var snap = await db.collection("usuarios").doc(idUsuario).get();
    Map<String, dynamic> dados = snap.data();
    setState(() {
      _nome = dados["nome"];
      _adm = dados["adm"];
    });
  }

  _deslogar() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  @override
  void initState() {
    super.initState();
    _recuperaListaCategorias();
    _recuperaUsuario();
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
                title: Text('Cadastrar Adm'),
                onTap: () {
                  Navigator.pushNamed(context, "/adm");
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
              leading: Icon(Icons.access_alarms_outlined),
              title: Text("Pedido em andamento"),
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
                leading: Icon(Icons.miscellaneous_services),
                title: Text("Lista serviços"),
                onTap: () {
                  Navigator.pushNamed(context, "/listaorcamento");
                },
              ),
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.update),
                title: Text('Pedidos pendentes'),
                onTap: () {
                  Navigator.pushNamed(context, "/listapedidos");
                },
              ),
            ),
            Visibility(
              visible: _adm,
              child: ListTile(
                leading: Icon(Icons.delivery_dining),
                title: Text('Entregas em andamento'),
                onTap: () {
                  Navigator.pushNamed(context, "/listaentregas");
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Meus pedidos'),
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
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor
        ),
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
                    child: Text("Sem categorias cadastradas"),
                  );
                } else {
                  return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      // ignore: missing_return
                      itemBuilder: (context, indice) {
                        List<QueryDocumentSnapshot> lista =
                            querySnapshot.docs.toList();
                        QueryDocumentSnapshot dados = lista[indice];
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 3,
                              color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          elevation: 8,
                          child: ListTile(
                            title: Text(dados["categoria"],
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            ),
                          ),
                        );
                      });
                }
                break;
            }
          },
        ),
      ),
    );
  }
}
