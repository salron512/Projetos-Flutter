import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListaProdutos extends StatefulWidget {
  var documentSnapshot;
  String id;
  ListaProdutos(this.documentSnapshot);

  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {

  _auteraStatus() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String idUsuario = auth.currentUser.uid;
    var snapshot = await db.collection("usuarios").doc(idUsuario).get();
    Map<String, dynamic> map = snapshot.data();
    var dados = widget.documentSnapshot[0];
    String id = dados["idUsuario"];
    print("id " + id );
    db.collection("pedido").doc(id).update({
      "idEntregador": map["idUsuario"],
      "nomeEntregador": map["nome"],
      "Data de saída": DateTime.now().toString(),
      "status": "recebido",
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista pedido"),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: widget.documentSnapshot.length,
          separatorBuilder: (context, indice) => Divider(
            height: 2,
            color: Colors.grey,
          ),
          itemBuilder: (context, indice) {
            var requisicoes = widget.documentSnapshot;
            var dados = requisicoes[indice];
            return CheckboxListTile(
                activeColor: Color(0xffFF0000),
                title: Text("Produto: " + dados["nome"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Marca: " + dados["marca"]),
                    Text("Quantidade: " + dados["quantidade"]),
                  ],
                ),
                value:  dados["estado"],
                onChanged: (valor) {
                  setState(() {
                    dados["estado"] = valor;
                  });
                }
                );
          },
        ),
      ),
      persistentFooterButtons: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: Text(
                "Confirmar Pedido",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
             style: ElevatedButton.styleFrom(
                primary: Color(0xffFF0000),
              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
             ),
              onPressed: () {
                _auteraStatus();
                Navigator.pushNamed(context, "/listaentregas");
              },
            ),
          ],
        )

      ],
    );
  }
}
