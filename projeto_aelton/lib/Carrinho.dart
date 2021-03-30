import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_aelton/model/Usuario.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  int index;
  String _nome = "";



  _recuperaDadosUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String id = auth.currentUser.uid;
    var dados = await db.collection("usuarios").doc(id).get();
     Map dadosUsuario = dados.data();
     if(dadosUsuario.isNotEmpty){
       setState(() {
         _nome = dadosUsuario["nome"];
       });
     }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cesta de compras"),
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
                  children:<Widget> [
                      Text(_nome,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
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

                });
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Segunda Tela'),
              onTap: () {
                setState(() {
                  index = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body:  Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
              child: Text("teste"),
            )
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_grocery_store),
        backgroundColor: Color(0xffFF0000),
        onPressed: () {
        },
      ),
    );
  }
}


