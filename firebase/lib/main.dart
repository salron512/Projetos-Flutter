import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firestore db = Firestore.instance;

  // faz consulta no banco de dados a cada alteracao no banco de forma automatica
  db.collection("usuarios").snapshots().listen((snapshot) {
    for (DocumentSnapshot item in snapshot.documents) {
      var dados = item.data;
      print("nome: " +
          dados["nome"].toString() +
          " idade:  " +
          dados["idade"].toString());
    }
  });

/*
//recupera dados do banco de dados
QuerySnapshot querySnapshot = await db.collection("usuarios").getDocuments();
 //print("dados usuarios: " + querySnapshot.documents.toString());
for(DocumentSnapshot item in querySnapshot.documents){
  var dados = item.data;
 print("dados usuarios: " + dados["nome"] + " idade: " + dados["idade"] );
}
*/

//recupera dados do banco de dados
  /*
DocumentSnapshot snapshot = await db.collection("usuarios").document("001").get();
var dados = snapshot.data;
print("dados: " + dados["nome"] + " idade: " + dados["idade"]);
*/

  // deleta registros no banco de dados
//db.collection("usuarios").document("003").delete();

/*
  db.collection("usuarios")
  .document("002")
  .setData({
    "nome" : "Julia",
    "idade": "28"
  });

   DocumentReference ref = await db.collection("noticias")
  .add({
    "titulo" : "Onde de calor em MT",
    "descricao" : "texto exemplo..."
  });
     print("item salvo: " + ref.documentID);


 db.collection("noticias")
  .document("8LqbYLuoBgLibHK49XYK")
  .setData({
   "titulo" : "Onda de Calor em MT - alterada",
   "descricao" : "texto de exemplo"
 });
*/
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
