import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  StreamController _controller = StreamController.broadcast();
  bool _adm = false;
  String _nome = "";

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

  _recuperaProdutos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("produtos")
        .orderBy("nome", descending: false)
        .snapshots()
        .listen((event) {
      _controller.add(event);
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
    _recuperaProdutos();
    _recuperaUsuario();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
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
                color: Color(0xffFF0000),
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
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SegundaTela()));
                setState(() {
                  Navigator.pushNamed(context, "/pedidousuario");
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
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        padding: EdgeInsets.only(right: 8, left: 8),
        child: StreamBuilder(
          stream: _controller.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text("Sem conexão"),
                );
                break;
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
                      "Sem imagens na galeria",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  );
                } else {
                  return GridView.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    children: List.generate(
                        // ignore: missing_return
                        querySnapshot.docs.length, (indice) {
                      List<DocumentSnapshot> urls = querySnapshot.docs.toList();
                      DocumentSnapshot dados = urls[indice];
                      // ignore: missing_required_param
                      return PhysicalModel(
                          shape: BoxShape.rectangle,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 8,
                          child: Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 60,
                                  child: Image.network(dados["urlImagem"]),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          dados["nome"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Text(
                                          "Marca: " + dados["marca"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Text(
                                          "R\$ " + dados["preco"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ));
                    }),
                  );
                }
                break;
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_grocery_store),
        backgroundColor: Color(0xffFF0000),
        onPressed: () {},
      ),
    );
  }
}
