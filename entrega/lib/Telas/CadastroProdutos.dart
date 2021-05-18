import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';

class CadastraProdutos extends StatefulWidget {
  @override
  _CadastraProdutosState createState() => _CadastraProdutosState();
}

class _CadastraProdutosState extends State<CadastraProdutos> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerPreco = TextEditingController();
  TextEditingController _controllerDescicao = TextEditingController();
  String _msgErro = "";

  _verificaCampos() {
    String nome = _controllerNome.text;
    String preco = _controllerPreco.text;
    String descricao = _controllerDescicao.text;
    if (nome.isNotEmpty) {
      if (preco.isNotEmpty) {
        if (preco.contains(",")) {
          setState(() {
            _msgErro = "O uso de vírgula não é permitido";
          });
        } else {
          if (descricao.isNotEmpty) {
            String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
            double precoFirebase = double.tryParse(preco).toDouble();
            String idDoc = DateTime.now().microsecondsSinceEpoch.toString();
            FirebaseFirestore.instance.collection("produtos").doc(idDoc).set({
              "idEmpresa": uid,
              "nome": nome,
              "descricao": descricao,
              "preco": precoFirebase.toStringAsFixed(2),
              "urlImagem": null,
            }).catchError((erro) {
              setState(() {
                _msgErro =
                    "Falha ao salvar os dados por favor verifique sua conexão";
              });
            });
            Navigator.pushNamed(context, "/perfilproduto", arguments: idDoc);
          } else {
            setState(() {
              _msgErro = "Por favor preencha a descrição do produto";
            });
          }
        }
      } else {
        setState(() {
          _msgErro = "Por favor preencha o preço do produto";
        });
      }
    } else {
      setState(() {
        _msgErro = "Por favor preencha o nome do produto";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de produto"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 150,
                height: 150,
                child: Image.asset("images/produto.png"),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8, top: 15),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      labelText: "Nome do produto",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  controller: _controllerNome,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "descrição do produto",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerDescicao),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      prefix: Text("R\$ "),
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      labelText: "Preço do produto",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  controller: _controllerPreco,
                ),
              ),
              Text(
                _msgErro,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: ElevatedButton(
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
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
      ),
    );
  }
}
