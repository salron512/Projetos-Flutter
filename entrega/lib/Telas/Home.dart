import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega/util/Categorias.dart';
import 'package:entrega/util/Localizacao.dart';
import 'package:entrega/util/RecupepraFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _adm = false;
  bool _empresa = false;
  bool _entregador = false;
  List<String> itensMenu = [
    "Cadastrar empresa",
    "Cadastrar entregador",
    "Indicações",
    "Lista entregador",
    "Lista empresas",
    "Financeiro",
  ];

  _deslogar() async {
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false));
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Cadastrar empresa":
        Navigator.pushNamed(context, "/cadastroEmpresa");
        break;
      case "Cadastrar entregador":
        Navigator.pushNamed(context, "/cadastroentregador");
        break;
      case "Lista entregador":
        Navigator.pushNamed(context, "/listaEntregadores");
        break;
      case "Financeiro":
        Navigator.pushNamed(context, "/financeiro");
        break;
      case "Lista empresas":
        Navigator.pushNamed(context, "/listaempresacadastro");
        break;
         case "Indicações":
        Navigator.pushNamed(context, "/indicacoes");
        break;
    }
  }

  Future _recuperaEmpresas() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("categorias")
        .orderBy("categoria", descending: false)
        .get();
    FirebaseStorage storage = FirebaseStorage.instance;
    List<Categorias> listaRecuperada = [];

    for (var item in snapshot.docs) {
      Map<String, dynamic> dados = item.data();
      Categorias categorias = Categorias();
      categorias.categoria = dados["categoria"];
      categorias.idImagem = dados["idImagem"];
      Reference imagem = storage.ref("categorias/" + categorias.idImagem);
      String url = await imagem.getDownloadURL();
      print("url " + url);
      categorias.urlImagem = url;
      listaRecuperada.add(categorias);
    }
    return listaRecuperada;
  }

  _recuperaUsuario() async {
    String uid = RecuperaFirebase.RECUPERAIDUSUARIO();
    Map<String, dynamic> map;
    DocumentSnapshot dadosUsuario =
        await FirebaseFirestore.instance.collection("usuarios").doc(uid).get();
    map = dadosUsuario.data();
    String tipoUsuario = map["tipoUsuario"];
    if (tipoUsuario == "empresa") {
      setState(() {
        _empresa = true;
      });
    }
    if (tipoUsuario == "adm") {
      setState(() {
        _adm = true;
      });
    }
    if (tipoUsuario == "entregador") {
      setState(() {
        _entregador = true;
      });
    }
  }

  _recebeNot() {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      // será chamado sempre que uma notificação for aberta / botão pressionado.
      // sempre que o content da notificação for aterado é necessario alterar o
      // o switch
      if (result != null) {
        String dados = result.notification.payload.body;

        print("ok " + dados);
        switch (dados) {
          case "Você tem uma nova entrega!":
            Navigator.pushNamed(context, "/listaEntregaPedentes");
            break;

          case "Você tem um novo pedido!":
            Navigator.pushNamed(context, "/listapedidosempresa");
            break;

          case "Acompanhe sua entrega em tempo real!":
            Navigator.pushNamed(context, "/listapedidousuario");
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Localizacao.verificaLocalizacao();
    _recuperaUsuario();
    _recebeNot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                _deslogar();
              }),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: _recuperaEmpresas(),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  List list = snapshot.data;
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, indice) {
                        Categorias dados = list[indice];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 8,
                          child: ListTile(
                            contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                            leading: Image.network(dados.urlImagem),
                            title: Text(
                              dados.categoria,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () async {
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied ||
                                  permission ==
                                      LocationPermission.deniedForever) {
                                Localizacao.verificaLocalizacao();
                              } else {
                                Navigator.pushNamed(context, "/listaempresas",
                                    arguments: dados.categoria);
                              }
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text(
                      "Lista de empresas vazia",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ));
                  }
                  break;
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
              width: 30,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: _adm,
                        child: PopupMenuButton<String>(
                          color: Color(0xff37474f),
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onSelected: _escolhaMenuItem,
                          // ignore: missing_return
                          itemBuilder: (context) {
                            return itensMenu.map((String item) {
                              return PopupMenuItem<String>(
                                value: item,
                                child: Text(item,
                                    style: TextStyle(color: Colors.white)),
                              );
                            }).toList();
                          },
                        )),
                    IconButton(
                        icon: Icon(
                          Icons.update,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_empresa) {
                            Navigator.pushNamed(
                                context, "/listapedidosempresa");
                          } else {
                            Navigator.pushNamed(context, "/listapedidousuario");
                          }
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_empresa) {
                            Navigator.pushNamed(
                                context, "/alteracadastroempresa");
                          } else {
                            Navigator.pushNamed(context, "/alteracadastro");
                          }
                        }),
                    Visibility(
                      visible: _empresa,
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/listaprodutos");
                          }),
                    ),
                    Visibility(
                      visible: _entregador,
                      child: IconButton(
                          icon: Icon(
                            Icons.delivery_dining_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, "/listaEntregaPedentes");
                          }),
                    ),
                    Visibility(
                      visible: _entregador,
                      child: IconButton(
                          icon: Icon(
                            Icons.sports_motorsports,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/minhasentregas");
                          }),
                    ),
                    Visibility(
                      visible: _entregador,
                      child: IconButton(
                          icon: Icon(
                            Icons.reorder,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/entregasrealizadas");
                          }),
                    ),
                    Visibility(
                      visible: _empresa,
                      child: IconButton(
                          icon: Icon(
                            Icons.reorder,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, "/listaentregasrealizadasempresa");
                          }),
                    ),
                  ],
                ),
              ))),
    );
  }
}
