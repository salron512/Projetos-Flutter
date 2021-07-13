import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastraProdutos extends StatefulWidget {
  @override
  _CadastraProdutosState createState() => _CadastraProdutosState();
}

class _CadastraProdutosState extends State<CadastraProdutos> {
  String _escolhaGrupo = '';
  List<String> _listaGrupo = [];
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerPreco = TextEditingController();
  TextEditingController _controllerDescicao = TextEditingController();
  TextEditingController _controllerQtdEstoque =
      TextEditingController(text: '0');
  var _mascaraQtd = MaskTextInputFormatter(
      mask: '#########', filter: {"#": RegExp(r'[0-9]')});
  String _msgErro = "";
  bool _estoque = false;

  _verificaCampos() async {
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
            if (_controllerQtdEstoque.text.isEmpty) {
              setState(() {
                _controllerQtdEstoque.text = '0';
              });
            }
            if (_escolhaGrupo.isNotEmpty) {
              String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
              int qtdEstoque = int.parse(_controllerQtdEstoque.text).toInt();
              double precoFirebase = double.tryParse(preco).toDouble();
              String idDoc = DateTime.now().microsecondsSinceEpoch.toString();
              await FirebaseFirestore.instance
                  .collection("produtos")
                  .doc()
                  .set({
                'status': true,
                'grupo': _escolhaGrupo,
                'estoqueAtivo': _estoque,
                'estoque': qtdEstoque,
                "id": idDoc,
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
              String idDocumento;
              CollectionReference query =
                  FirebaseFirestore.instance.collection("produtos");
              QuerySnapshot snap = await query
                  .where("idEmpresa", isEqualTo: uid)
                  .where("id", isEqualTo: idDoc)
                  .get();
              for (var item in snap.docs) {
                idDocumento = item.reference.id;
              }
              print("idDoc " + idDocumento);
              Navigator.pushNamed(context, "/perfilproduto",
                  arguments: idDocumento);
            } else {
              setState(() {
                _msgErro = "Por favor escolha um grupo de produtos";
              });
            }
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

  _recuperaGruposProdutos() async {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("grupoProduto")
        .where("idEmpresa", isEqualTo: uid)
        .get();
    for (var item in snapshot.docs) {
      Map dados = item.data();
      String grupoNome = dados['nome'];
      _listaGrupo.add(grupoNome);
    }
  }

  _alertGrupo() {
    showDialog(
        context: context,
        builder: (contex) {
          return AlertDialog(
            title: Text('Grupos de produto'),
            content: Container(
              width: 250,
              height: 250,
              child: ListView.separated(
                itemCount: _listaGrupo.length,
                separatorBuilder: (context, indice) => Divider(
                  height: 4,
                  color: Colors.grey,
                ),
                itemBuilder: (context, indice) {
                  String grupo = _listaGrupo[indice];
                  return ListTile(
                    title: Text(grupo),
                    onTap: () {
                      setState(() {
                        _escolhaGrupo = grupo;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaGruposProdutos();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, top: 15),
                    child: Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: _estoque,
                      onChanged: (value) {
                        setState(() {
                          _estoque = value;
                        });
                      },
                    ),
                  ),
                  Text("Estoque")
                ],
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
              Visibility(
                visible: _estoque,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [_mascaraQtd],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Quantidade em estoque",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerQtdEstoque,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  child: Text("Grupo escolhido " + _escolhaGrupo),
                  onTap: () {
                    _alertGrupo();
                  },
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
