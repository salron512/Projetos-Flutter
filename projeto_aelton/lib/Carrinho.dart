import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_aelton/model/Produtos.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  StreamController _controller = StreamController.broadcast();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerMarca = TextEditingController();
  TextEditingController _controllerProduto = TextEditingController();
  List<Produtos> _listaRecuperadaProdutos = [];
  bool _retorno;
  bool _estado = false;
  int index;
  String _nome = "";
  bool _mostraCadastroProdutos = false;

  _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String id = auth.currentUser.uid;
    var dados = await db.collection("usuarios").doc(id).get();
    Map dadosUsuario = dados.data();
    if (dadosUsuario.isNotEmpty) {
      setState(() {
        _nome = dadosUsuario["nome"];
        _mostraCadastroProdutos = dadosUsuario["adm"];
      });
    }
  }

  _confirmarPedido() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String id = auth.currentUser.uid;

    if (_retorno) {
      var dados = await db.collection("pedido").doc(id).get();
      if (!dados.exists) {
        var user = await db.collection("usuarios").doc(id).get();
        Map<String, dynamic> map = user.data();
        _mostraErro("Pedido Realizado com sucesso");
        await db.collection("pedido").doc(id).set({
          "idUsuario": id,
          "nome": map["nome"],
          "telefone": map["telefone"],
          "whatsapp": map["whatsapp"],
          "endereco": map["endereco"],
          "bairro": map["bairro"],
          "cidade": map["cidade"],
          "pontoReferencia": map["pontoReferencia"],
          "status": "pendente",
          "data": DateTime.now().toString(),
        });
        var dados = await db
            .collection("requisicoesAtivas")
            .where("status", isEqualTo: "pendente")
            .where("idUsuario", isEqualTo: id)
            .get();
        List list = [];
        for (var item in dados.docs) {
          Map<String, dynamic> dados = item.data();
          list.add(dados);
        }
        db.collection("pedido").doc(id).update({"listaCompras": list});
        db.collection("requisicoesAtivas")
          .where("status", isEqualTo: "pendente")
            .where("idUsuario", isEqualTo: id).get().then((value){
              value.docs.forEach((element) {
               db..collection("requisicoesAtivas").doc(element.id).delete();
              });
      });


      } else {
        _mostraErro("Você já tem um pedido em adamento");
      }
    } else {
      _mostraErro("Adicione produtos ao carrinho");
    }
  }

  _recuperaProdutos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var snaphot = await db
        .collection("produtos")
        .orderBy("nome", descending: false)
        .get();

    for (var item in snaphot.docs) {
      Map<String, dynamic> dados = item.data();
      Produtos produtos = Produtos();
      produtos.nome = dados["nome"];
      produtos.marca = dados["marca"];
      _listaRecuperadaProdutos.add(produtos);
    }
  }

  _salvaProduto(String nome, String marca) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Digite a quantidade"),
            content: Container(
              height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      "images/cart.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text("Produto: " + nome),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text("Marca: " + marca),
                  ),
                  TextField(
                    controller: _controllerProduto,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Digite a quantidade do produto",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  if (_controllerProduto.text.contains(".") ||
                      _controllerProduto.text.contains("-") ||
                      _controllerProduto.text.contains(",") ||
                      _controllerProduto.text.isEmpty) {
                    _mostraErro("Quantidade inválida");
                  } else {
                    FirebaseFirestore db = FirebaseFirestore.instance;
                    FirebaseAuth auth = FirebaseAuth.instance;
                    String id = auth.currentUser.uid;
                    Produtos produtos = Produtos();
                    produtos.nome = nome;
                    produtos.marca = marca;
                    produtos.qtd = _controllerProduto.text;
                    db.collection("requisicoesAtivas").doc().set({
                      "idUsuario": id,
                      "nome": nome,
                      "marca": marca,
                      "quantidade": _controllerProduto.text,
                      "status": "pendente",
                      "estado": _estado,
                      "data": DateTime.now(),
                    });
                    _controllerProduto.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _mostraErro(String msg) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Menssagem"),
            content: Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.asset("images/cart.png"),
                    ),
                  ),
                  Text(
                    msg,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  _controllerProduto.clear();
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  _adicionaProduto() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Produtos"),
            content: Container(
              width: 150,
              height: 250,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _listaRecuperadaProdutos.length,
                separatorBuilder: (context, indice) => Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                // ignore: missing_return
                itemBuilder: (context, indice) {
                  var item = _listaRecuperadaProdutos[indice];
                  return ListTile(
                    title: Text("Produto: " + item.nome),
                    subtitle: Text("Marca: " + item.marca),
                    onTap: () {
                      Navigator.pop(context);
                      _salvaProduto(item.nome, item.marca);
                    },
                  );
                },
              ),
            ),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }

  _deslogar() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  Stream _recuperaItensCarrinho() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String id = auth.currentUser.uid;
    var stream = db
        .collection("requisicoesAtivas")
        .where("status", isEqualTo: "pendente")
        .where("idUsuario", isEqualTo: id)
        .snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  _editaProduto(String nome, String marca, String id) {
    setState(() {
      _controllerNome.text = nome;
      _controllerMarca.text = marca;
    });
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Dados do produtos"),
            content: Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Image.asset("images/solicitacao.png"),
                    ),
                  ),
                  TextField(
                    controller: _controllerProduto,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Quantidade do produto",
                    ),
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  if (_controllerProduto.text.contains(".") ||
                      _controllerProduto.text.contains(",") ||
                      _controllerProduto.text.contains("-")) {
                    _mostraErro("Quantidade inválida");
                  } else {
                    FirebaseFirestore db = FirebaseFirestore.instance;
                    db.collection("requisicoesAtivas").doc(id).update({
                      "quantidade": _controllerProduto.text,
                    });
                    Navigator.pop(context);
                    _controllerProduto.clear();
                  }
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _apagaProduto(String nome, String marca, String id) {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir produtos"),
            content: Container(
              height: 250,
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
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Produto: " + nome),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Marca: " + marca),
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  db.collection("requisicoesAtivas").doc(id).delete();
                  Navigator.pop(context);
                },
                child: Text("Deletar"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
    _recuperaItensCarrinho();
    _recuperaProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho de compra"),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.asset("images/usericon.png"),
                    ),
                    Text(
                      _nome,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xffFF0000),
              ),
            ),
            Visibility(
              visible: _mostraCadastroProdutos,
              child: ListTile(
                leading: Icon(Icons.people_alt),
                title: Text('Cadastrar Adm'),
                onTap: () {
                  Navigator.pushNamed(context, "/adm");
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text("Alterar cadastro"),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SegundaTela()));
                setState(() {
                  Navigator.pushNamed(context, "/config");
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.access_alarms_outlined),
              title: Text("Pedido em andamento"),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SegundaTela()));
                setState(() {
                  Navigator.pushNamed(context, "/pedidousuario");
                });
              },
            ),
            Visibility(
              visible: _mostraCadastroProdutos,
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('Cadastro de produtos'),
                onTap: () {
                  Navigator.pushNamed(context, "/produtos");
                },
              ),
            ),
            Visibility(
              visible: _mostraCadastroProdutos,
              child: ListTile(
                leading: Icon(Icons.update),
                title: Text('Pedidos pendentes'),
                onTap: () {
                  Navigator.pushNamed(context, "/listapedidos");
                },
              ),
            ),
            Visibility(
              visible: _mostraCadastroProdutos,
              child: ListTile(
                leading: Icon(Icons.delivery_dining),
                title: Text('Entregas em andamento'),
                onTap: () {
                  Navigator.pushNamed(context, "/listaentregas");
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Meus pedidos'),
              onTap: () {
                Navigator.pushNamed(context, "/minhasentregas");
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                _deslogar();
              },
            ),
          ],
        ),
      ),
      body: Center(
          //padding: EdgeInsets.all(16),
          child: StreamBuilder(
        stream: _controller.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot querySnapshot = snapshot.data;
              if (querySnapshot.docs.length == 0) {
                _retorno = false;
                return Center(
                  child: Text(
                    "Sem produtos no carrinho!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                _retorno = true;
                return ListView.separated(
                  itemCount: querySnapshot.docs.length,
                  separatorBuilder: (context, indice) => Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  itemBuilder: (context, indice) {
                    List<DocumentSnapshot> requisicoes =
                        querySnapshot.docs.toList();
                    DocumentSnapshot dados = requisicoes[indice];
                    return ListTile(
                      title: Text("Produto: " + dados["nome"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Marca: " + dados["marca"]),
                          Text("Quantidade: " + dados["quantidade"]),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                _editaProduto(dados["nome"], dados["marca"],
                                    dados.reference.id);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _apagaProduto(dados["nome"], dados["marca"],
                                    dados.reference.id);
                              }),
                        ],
                      ),
                    );
                  },
                );
              }
              break;
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_grocery_store),
        backgroundColor: Color(0xffFF0000),
        onPressed: () {
          _adicionaProduto();
        },
      ),
      persistentFooterButtons: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RaisedButton(
              child: Text(
                "Confirmar Pedido",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Color(0xffFF0000),
              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                _confirmarPedido();
              },
            ),
          ],
        )
      ],
    );
  }
}
