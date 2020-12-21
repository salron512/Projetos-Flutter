import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/Conversa.dart';

class Conversas extends StatefulWidget {
  @override
  _ConversasState createState() => _ConversasState();
}

class _ConversasState extends State<Conversas> {
  List<Conversa> listaConversas = [
    Conversa("Jose Renato", "olá tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-eea4d.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=4fc3f109-2fa2-4e81-a5f8-8ec4872bb18d"),
    Conversa("Jamilton", "olá tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-eea4d.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=b5d2ec90-e9ed-4916-bdb1-90337d669ad9"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listaConversas.length,
        // ignore: missing_return
        itemBuilder: (context, indice) {
          // ignore: missing_return
          Conversa conversa = listaConversas[indice];

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(conversa.caminhoFoto),
            ),
            title: Text(
              conversa.nome,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              conversa.mensagem,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        });
  }
}
