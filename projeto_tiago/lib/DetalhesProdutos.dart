import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetalhesProdutos extends StatefulWidget {
  DetalhesProdutos({Key key}) : super(key: key);

  @override
  _DetalhesProdutosState createState() => _DetalhesProdutosState();
}

class _DetalhesProdutosState extends State<DetalhesProdutos> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerMarca = TextEditingController();
  TextEditingController _controllerPreco = TextEditingController();
  String _msgErro = "";
  List<String> _listaCategoria = [];
  String _categoriaSelecionada = "";

  _recuperaCategoria() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var snapshot = await db.collection("categorias").get();

    for (var item in snapshot.docs) {
      Map<String, dynamic> docs = item.data();
      _listaCategoria.add(docs["categoria"]);
    }
    return _listaCategoria;
  }

  _verificaCampos() async {
    // ignore: unused_local_variable
    if (_controllerNome.text.isNotEmpty) {
      if (_controllerMarca.text.isNotEmpty) {
        if (_controllerPreco.text.isNotEmpty) {
          if (_categoriaSelecionada.isNotEmpty) {
            if (_controllerPreco.text.contains(",")) {
              setState(() {
                _msgErro = "O uso de vírgula não é permitido";
              });
            } else {
              FirebaseFirestore db = FirebaseFirestore.instance;
              String id = DateTime.now().microsecondsSinceEpoch.toString();
              await db.collection("produtos").doc(id).set({
                "id": id,
                "categoria": _categoriaSelecionada,
                "nome": _controllerNome.text,
                "marca": _controllerMarca.text,
                "preco": _controllerPreco.text,
                "urlImagem": null,
                // ignore: missing_return
              });
              Navigator.pushNamed(context, "/grid", arguments: id);
            }
          } else {
            setState(() {
              _msgErro = "Por favor selecione uma categoria";
            });
          }
        } else {
          setState(() {
            _msgErro = "Por favor preencha o campo preço";
          });
        }
      } else {
        setState(() {
          _msgErro = "Por favor preencha o campo marca";
        });
      }
    } else {
      setState(() {
        _msgErro = "Por favor preencha o campo nome";
      });
    }
  }

  _alertCategoria() {
    showDialog(
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Cadastro da categoria"),
            content: Container(
                height: 150,
                child: ListView.separated(
                  itemCount: _listaCategoria.length,
                  separatorBuilder: (context, indice) => Divider(
                    height: 4,
                    color: Colors.grey,
                  ),
                  // ignore: missing_return
                  itemBuilder: (context, indice) {
                    var dados = _listaCategoria[indice];
                    return ListTile(
                      title: Text(dados),
                      onTap: () {
                        Navigator.pop(context);
                       setState(() {
                          _categoriaSelecionada = dados;
                       });
                      },
                    );
                  },
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controllerNome.clear();
                  _controllerMarca..clear();
                },
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recuperaCategoria();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de produtos"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  _msgErro,
                  style: TextStyle(color: Colors.red),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text("Categoria selecionada: " +
                  _categoriaSelecionada,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),
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
                      //hintText: "Nome do produto",
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
                      labelText: "Marca do produto",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  controller: _controllerMarca,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      prefix: Text("R\$ "),
                      //hintText: "Nome do produto",
                      labelText: "Preço do produto",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  controller: _controllerPreco,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  child: Text(
                    "Selecionar categoria",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  onTap: () {
                    _alertCategoria();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
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
                    _verificaCampos();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
