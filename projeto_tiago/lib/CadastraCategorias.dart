import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CadastraCategoias extends StatefulWidget {
  @override
  _CadastraCategoiasState createState() => _CadastraCategoiasState();
}

class _CadastraCategoiasState extends State<CadastraCategoias> {
  TextEditingController _controllerCategoria = TextEditingController();
  String _msgErro = "";

  _salvaCadastro() async {
    String categoria = _controllerCategoria.text;

    if (categoria.isNotEmpty) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      String id = DateTime.now().microsecondsSinceEpoch.toString();
      await db
          .collection("categorias")
          .doc(id)
          .set({"id": id, "categoria": categoria, "urlImagem": null}).then(
              (value) => Navigator.pushNamed(context, "/perfilcategoria",
                  arguments: id));
    } else {
      setState(() {
        _msgErro = "Preencha o campo categoria";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de categorias"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              _msgErro,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 15),
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
                  hintText: "Nome da categoria",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
              controller: _controllerCategoria),
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 10),
            child: ElevatedButton(
              child: Text(
                "Cadastrar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xffFF0000),
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                _salvaCadastro();
              },
            ),
          ),
        ]),
      ),
    );
  }
}
