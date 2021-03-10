import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber/util/StatusRequisicao.dart';

class PainelMotorista extends StatefulWidget {
  @override
  _PainelMotoristaState createState() => _PainelMotoristaState();
}

class _PainelMotoristaState extends State<PainelMotorista> {
  List<String> _escolha = ["Configuração", "Deslogar"];
  final _controller = StreamController.broadcast();
  Firestore _db = Firestore.instance;
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

  Stream _adicionarListenerRequisicoes() {
    final stream = _db
        .collection("requisicoes")
        .where("status", isEqualTo: StatusRequisicao.AGUARDANDO)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerRequisicoes();
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
      body: StreamBuilder(
        stream: _controller.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Column(
                    children: [
                      Padding(
                       padding: EdgeInsets.all(8),
                         child: CircularProgressIndicator(),
                  ),
                  Text("Carregando requisições!")
                ],
              ));
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar!");
              } else {
                QuerySnapshot querySnapshot = snapshot.data;
                if (querySnapshot.documents.length == 0) {
                  return Center(
                    child:  Text("Sem corridas no momento!"),
                  );
                } else {
                  return ListView.separated(
                      itemCount: querySnapshot.documents.length,
                    separatorBuilder: (context, indice)=> Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                      // ignore: missing_return
                      itemBuilder: (context, indice){
                        List<DocumentSnapshot>
                        requisicoes = querySnapshot.documents.toList();
                        DocumentSnapshot item = requisicoes[indice];
                        String idRequisicao = item["id"];
                        String nomePassageiro = item["passageiro"]["nome"];
                        String rua = item["destino"]["rua"];
                        String numero = item["destino"]["numero"];
                        return ListTile(
                          title: Text(nomePassageiro),
                          subtitle: Text("Destino: $rua, $numero"),
                            onTap: (){
                            Navigator.pushNamed(context, "/Corrida", arguments:
                            idRequisicao);
                        },
                        );
                      },
                  );
                }
              }
              break;
          }
        },
      ),
    );
  }
}
