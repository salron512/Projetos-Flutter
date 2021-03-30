import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesPedido extends StatefulWidget {
  DocumentSnapshot dados;
  DetalhesPedido(this.dados);
  @override
  _DetalhesPedidoState createState() => _DetalhesPedidoState();
}

class _DetalhesPedidoState extends State<DetalhesPedido> {
  _abrirWhatsApp() async {
    String telefone = widget.dados["whatsapp"];
    var whatsappUrl = "whatsapp://send?phone=+55$telefone=Olá,tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  _abrirTelefone() async {
    String telefone = widget.dados["telefone"];
    var telefoneUrl = "tel:$telefone";

    if (await canLaunch(telefoneUrl)) {
      await launch(telefoneUrl);
    } else {
      throw 'Could not launch $telefoneUrl';
    }
  }

  _alteraPedido() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("solicitacao").doc(widget.dados.reference.id).update({
      "status": "Não atendido",
      "idProfissional": " ",
      "idProfissional": " ",
      "nomeProfissional": " ",
      "telefoneProfissional": " ",
      "dataResposta": " ",
    });
    Navigator.pop(context);
  }

  _alertAlterar() {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar desistencia"),
            content: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/excluir.png"),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  _alteraPedido();
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffDCDCDC)),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image.asset(
                  "images/comunicacao.png",
                  width: 200,
                  height: 150,
                ),
              ),
              Text(
                "Nome do cliente: " + widget.dados["nome"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Descrição: " + widget.dados["descricao"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16, top: 16),
                child: RaisedButton(
                  child: Text(
                    "Whatasapp",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    _abrirWhatsApp();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: RaisedButton(
                  child: Text(
                    "Telefone",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xff37474f),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    _abrirTelefone();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: RaisedButton(
                  child: Text(
                    "Desistir do atendimento",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.red,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    _alertAlterar();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
