import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PainelMotorista extends StatefulWidget {
  @override
  _PainelMotoristaState createState() => _PainelMotoristaState();
}

class _PainelMotoristaState extends State<PainelMotorista> {
  List<String> _escolha = ["Configuração", "Deslogar"];

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Configuração":
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Painel Motorista"),
          actions: [
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              // ignore: missing_return
              itemBuilder: (context) {
                return _escolha.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Center(
          child: Text("motorista"),
        ));
  }
}
