import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();

 Firestore db =  Firestore.instance;
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
     print("item salva: " + ref.documentID);


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
