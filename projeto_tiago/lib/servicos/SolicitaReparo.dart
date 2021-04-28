import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:projeto_tiago/util/RecuperaDadosFirebase.dart';

class SolicitaReparo extends StatefulWidget {
  SolicitaReparo({Key key}) : super(key: key);

  @override
  _SolicitaReparoState createState() => _SolicitaReparoState();
}

class _SolicitaReparoState extends State<SolicitaReparo> {
  TextEditingController _controllerModelo = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  TextEditingController _controllerSenhaAparelho = TextEditingController();
  String _msg = "";
  Color _cor = Colors.white;

  _enviaAlerta() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<String> list = [];
    var snapshot =
        await db.collection("usuarios").where("adm", isEqualTo: true).get();

    for (var item in snapshot.docs) {
      Map<String, dynamic> map = item.data();
      String idUsuarioNotigicacao = map["playerId"];
      list.add(idUsuarioNotigicacao);
    }
    OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: list,
      heading: "Solicitaçao de orçamento",
      content: "Você tem uma nova solicitação de orçamento!",
    ));
  }

  _salvarSolicitaca(String modelo, String descricao, String senha) async {
    String uid = RecuperaDadosFirebase.RECUPERAUSUARIO();
    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String, dynamic> dadosUsuario;

    if (senha.isNotEmpty) {
      DocumentSnapshot snapshot =
          await db.collection("usuarios").doc(uid).get();
      dadosUsuario = snapshot.data();
      db.collection("reparos").doc().set({
        "idUsuario": uid,
        "modeloAparelho": modelo,
        "descricao": descricao,
        "senha": senha,
        "nomeUsuario": dadosUsuario["nome"],
        "telefone": dadosUsuario["telefone"],
        "whatsapp": dadosUsuario["whatsapp"],
        "endereco": dadosUsuario["endereco"],
        "bairro": dadosUsuario["bairro"],
        "pontoReferencia": dadosUsuario["pontoReferencia"],
        "data": DateTime.now().toString(),
      }).then((value) {
        setState(() {
          _cor = Colors.white;
          _msg = "Solicitação enviada com sucesso!";
          _controllerDescricao.clear();
          _controllerModelo.clear();
          _controllerSenhaAparelho.clear();
        });
        _enviaAlerta();
      }).catchError((erro) {
        setState(() {
          _cor = Colors.red;
          _msg = "Erro ao enviar solicitação por favor verifique sua conexão";
        });
      });
    } else {
      DocumentSnapshot snapshot =
          await db.collection("usuarios").doc(uid).get();
      dadosUsuario = snapshot.data();
      db.collection("reparos").doc().set({
        "idUsuario": uid,
        "modeloAparelho": modelo,
        "descricao": descricao,
        "senha": "Senha não informada",
        "nomeUsuario": dadosUsuario["nome"],
        "telefone": dadosUsuario["telefone"],
        "whatsapp": dadosUsuario["whatsapp"],
        "endereco": dadosUsuario["endereco"],
        "bairro": dadosUsuario["bairro"],
        "pontoReferencia": dadosUsuario["pontoReferencia"],
        "data": DateTime.now().toString(),
      }).then((value) {
        setState(() {
          _cor = Colors.white;
          _msg = "solicitação enviada com sucesso!";
          _controllerDescricao.clear();
          _controllerModelo.clear();
          _controllerSenhaAparelho.clear();
        });
        _enviaAlerta();
      }).catchError((erro) {
        setState(() {
          _cor = Colors.red;
          _msg = "Erro ao enviar solicitação por favor verifique sua conexão";
        });
      });
    }
  }

  _verificaCampos() {
    String modelo = _controllerModelo.text;
    String descricao = _controllerDescricao.text;
    String senha = _controllerSenhaAparelho.text;
    if (modelo.isNotEmpty) {
      if (descricao.isNotEmpty) {
        _salvarSolicitaca(modelo, descricao, senha);
      } else {
        setState(() {
          _cor = Colors.red;
          _msg = "Preencha o campo descrição";
        });
      }
    } else {
      setState(() {
        _cor = Colors.red;
        _msg = "Preencha o campo modelo ";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitar reparo"),
      ),
      body: Container(
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      "images/repair.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          _msg,
                          style: TextStyle(
                            color: _cor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Modelo do aparelho",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerModelo,
                    ),
                  ),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Descrição do problema",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerDescricao,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Senha do aparelho",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerSenhaAparelho,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ElevatedButton(
                      child: Text(
                        "Solicitar orçamento",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffFF0000),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        _verificaCampos();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
