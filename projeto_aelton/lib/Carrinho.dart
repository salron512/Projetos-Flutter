import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  StreamController _controller = StreamController.broadcast();
  int index;
  String _nome = "";
  bool _mostraCadastroProdutos = false;

  _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String id = auth.currentUser.uid;
    var dados = await db.collection("usuarios").doc(id).get();
    Map dadosUsuario = dados.data();
    if (dadosUsuario.isNotEmpty) {
      setState(() {
        _nome = dadosUsuario["nome"];
        _mostraCadastroProdutos = dadosUsuario["adm"];
      });
    }
  }

  _deslogar() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  Stream _recuperaProdutos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db.collection("produtos")
        .orderBy("nome", descending: false)
        .snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
    _recuperaProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
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
           Visibility(
             visible: _mostraCadastroProdutos,
               child: ListTile(
                 leading: Icon(Icons.add),
                 title: Text('Cadastro de produtos'),
                 onTap: () {
                   Navigator.pushNamed(context, "/produtos");
                 },
               ),
           ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Meus pedidos'),
              onTap: () {
              },
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
      ), body: Center(
    //padding: EdgeInsets.all(16),
    child: StreamBuilder(
    stream: _controller.stream,
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (querySnapshot.docs.length == 0) {
              return Center(
                child: Text(
                  "Sem produtos cadastrados!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return ListView.separated(
                itemCount: querySnapshot.docs.length,
                separatorBuilder: (context, indice) => Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                itemBuilder: (context, indice) {
                  List<DocumentSnapshot> requisicoes =
                  querySnapshot.docs.toList();
                  DocumentSnapshot dados = requisicoes[indice];
                  return ListTile(
                    title: Text("Produto: " + dados["nome"]),
                    subtitle: Text("Marca: " + dados["marca"]),
                  );
                },
              );
            }
            break;
        }
      },
    )
    ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_grocery_store),
        backgroundColor: Color(0xffFF0000),
        onPressed: () {},
      ),
    );
  }
}
