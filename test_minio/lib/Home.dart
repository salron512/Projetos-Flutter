import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Dados.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var _auth = FirebaseAuth.instance;

  Dados dados = Dados();
  var resultado;
  int index;
  _consulta() async {
    var token = await _auth.currentUser.getIdToken();

    String url =
        "https://lista-albuns-default-rtdb.firebaseio.com/artista.json?auth=$token";

    http.Response response = await http.get(url);
    setState(() {
      resultado = jsonDecode(response.body);
    });
    print("Status: " + response.statusCode.toString());
    print("retorno API: " + resultado);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _consulta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista Albuns"),
          actions: [
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.exit_to_app),
              ),
              onTap: () {
                _auth.signOut();
                Navigator.popAndPushNamed(context, "/login");
              },
            ),
          ],
        ),
        body: resultado == null
            ? Container(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    // valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(color: Colors.blue),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        //color: Colors.lightBlueAccent,
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Serj tankian"]["albuns"]
                                  ["Black Blooms"]["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Serj tankian"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Serj tankian"]["albuns"]
                                  ["Black Blooms"]["titulo"];
                              dados.ano = resultado["Serj tankian"]["albuns"]
                                      ["Black Blooms"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Serj tankian"]
                                      ["albuns"]["Black Blooms"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Serj tankian"]
                                      ["albuns"]["Black Blooms"]["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Serj tankian"]["nome"];
                              dados.object = "black-blooms.jpg";
                              dados.objectUpload = "black-blooms/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Serj tankian"]["albuns"]["Harakiri"]
                                  ["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Serj tankian"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Serj tankian"]["albuns"]
                                  ["Harakiri"]["titulo"];
                              dados.ano = resultado["Serj tankian"]["albuns"]
                                      ["Harakiri"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Serj tankian"]
                                      ["albuns"]["Harakiri"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Serj tankian"]
                                      ["albuns"]["Harakiri"]["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Serj tankian"]["nome"];
                              dados.object = "perfil_Harakiri.jpg";
                              dados.objectUpload = "harakiri/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Serj tankian"]["albuns"]
                                  ["The Rough Dog"]["titulo"]),
                          subtitle: Text("Artista: " +
                              resultado["Serj tankian"]["nome"].toString()),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Serj tankian"]["albuns"]
                                  ["The Rough Dog"]["titulo"];
                              dados.ano = resultado["Serj tankian"]["albuns"]
                                      ["The Rough Dog"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Serj tankian"]
                                      ["albuns"]["The Rough Dog"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Serj tankian"]
                                          ["albuns"]["The Rough Dog"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Serj tankian"]["nome"];
                              dados.object = "trd.jpg";
                              dados.objectUpload = "trd/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Mike Shinoda"]["albuns"]
                                  ["Post  Traumatic EP"]["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Mike Shinoda"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Mike Shinoda"]["albuns"]
                                  ["Post  Traumatic EP"]["titulo"];
                              dados.ano = resultado["Mike Shinoda"]["albuns"]
                                      ["Post  Traumatic EP"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Mike Shinoda"]
                                          ["albuns"]["Post  Traumatic EP"]
                                      ["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Mike Shinoda"]
                                          ["albuns"]["Post  Traumatic EP"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Mike Shinoda"]["nome"];
                              dados.object = "Post_Traumatic_EP.jpg";
                              dados.objectUpload = "Post_Traumatic_EP/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Mike Shinoda"]["albuns"]
                                  ["Post Traumatic"]["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Mike Shinoda"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Mike Shinoda"]["albuns"]
                                  ["Post Traumatic"]["titulo"];
                              dados.ano = resultado["Mike Shinoda"]["albuns"]
                                      ["Post Traumatic"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Mike Shinoda"]
                                      ["albuns"]["Post Traumatic"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Mike Shinoda"]
                                          ["albuns"]["Post Traumatic"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Mike Shinoda"]["nome"];
                              dados.object = "post traumatic.jpg";
                              dados.objectUpload = "pt/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Mike Shinoda"]["albuns"]
                                  ["The Rising Tied"]["titulo"]),
                          subtitle: Text("Artista: " +
                              resultado["Mike Shinoda"]["nome"].toString()),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Mike Shinoda"]["albuns"]
                                  ["The Rising Tied"]["titulo"];
                              dados.ano = resultado["Mike Shinoda"]["albuns"]
                                      ["The Rising Tied"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Mike Shinoda"]
                                      ["albuns"]["The Rising Tied"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Mike Shinoda"]
                                          ["albuns"]["The Rising Tied"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Mike Shinoda"]["nome"];
                              dados.object = 'The Rising Tied.jpeg';
                              dados.objectUpload = "trt/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Mike Shinoda"]["albuns"]
                                  ["Where'd You Go"]["titulo"]),
                          subtitle: Text("Artista: " +
                              resultado["Mike Shinoda"]["nome"].toString()),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Mike Shinoda"]["albuns"]
                                  ["Where'd You Go"]["titulo"];
                              dados.ano = resultado["Mike Shinoda"]["albuns"]
                                      ["Where'd You Go"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Mike Shinoda"]
                                      ["albuns"]["Where'd You Go"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Mike Shinoda"]
                                          ["albuns"]["Where'd You Go"]
                                      ["total-faixas"]
                                  .toString();
                              dados.object = "where.jpg";
                              dados.objectUpload = "where/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Michel Teló"]["albuns"]
                                  ["Bem Sertanejo"]["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Michel Teló"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Michel Teló"]["albuns"]
                                  ["Bem Sertanejo"]["titulo"];
                              dados.ano = resultado["Michel Teló"]["albuns"]
                                      ["Bem Sertanejo"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Michel Teló"]["albuns"]
                                      ["Bem Sertanejo"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Michel Teló"]
                                          ["albuns"]["Bem Sertanejo"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Michel Teló"]["nome"];
                              dados.object = "bem_sertanejo.jpg";
                              dados.objectUpload = "bs/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Michel Teló"]["albuns"]
                                  ["Bem Sertanejo - Ep"]["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Michel Teló"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Michel Teló"]["albuns"]
                                  ["Bem Sertanejo - Ep"]["titulo"];
                              dados.ano = resultado["Michel Teló"]["albuns"]
                                      ["Bem Sertanejo - Ep"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Michel Teló"]["albuns"]
                                      ["Bem Sertanejo - Ep"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Michel Teló"]
                                          ["albuns"]["Bem Sertanejo - Ep"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Michel Teló"]["nome"];
                              dados.object = "bem_sertanejo_EP.jpg";
                              dados.objectUpload = "bs_EP/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Michel Teló"]["albuns"]
                                      ["Bem Sertanejo - O Show (Ao Vivo)"]
                                  ["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Michel Teló"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Michel Teló"]["albuns"]
                                      ["Bem Sertanejo - O Show (Ao Vivo)"]
                                  ["titulo"];
                              dados.ano = resultado["Michel Teló"]["albuns"]
                                          ["Bem Sertanejo - O Show (Ao Vivo)"]
                                      ["ano"]
                                  .toString();
                              dados.duracao = resultado["Michel Teló"]["albuns"]
                                          ["Bem Sertanejo - O Show (Ao Vivo)"]
                                      ["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Michel Teló"]
                                              ["albuns"]
                                          ["Bem Sertanejo - O Show (Ao Vivo)"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Michel Teló"]["nome"];
                              dados.object = "bem_sertanejo_aovivo.jpg";
                              dados.objectUpload = "bs_aovivo/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Guns N' Roses"]["albuns"]
                                  ["Greatest Hits"]["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Guns N' Roses"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Guns N' Roses"]["albuns"]
                                  ["Greatest Hits"]["titulo"];
                              dados.ano = resultado["Guns N' Roses"]["albuns"]
                                      ["Greatest Hits"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Guns N' Roses"]
                                      ["albuns"]["Greatest Hits"]["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Guns N' Roses"]
                                          ["albuns"]["Greatest Hits"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Guns N' Roses"]["nome"];
                              dados.object = "Greatest_Hits.jpg";
                              dados.objectUpload = "greatest/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Guns N' Roses"]["albuns"]
                                  ["Use Your IIIlusion I"]["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Guns N' Roses"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Guns N' Roses"]["albuns"]
                                  ["Use Your IIIlusion I"]["titulo"];
                              dados.ano = resultado["Guns N' Roses"]["albuns"]
                                      ["Use Your IIIlusion I"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Guns N' Roses"]
                                          ["albuns"]["Use Your IIIlusion I"]
                                      ["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Guns N' Roses"]
                                          ["albuns"]["Use Your IIIlusion I"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Guns N' Roses"]["nome"];
                              dados.object = "Use Your IIIlusion I.jpg";
                              dados.objectUpload = "use_your1/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Album: " +
                              resultado["Guns N' Roses"]["albuns"]
                                  ["Use Your IIIlusion II"]["titulo"]),
                          subtitle: Text(
                              "Artista: " + resultado["Guns N' Roses"]["nome"]),
                          onTap: () {
                            setState(() {
                              dados.album = resultado["Guns N' Roses"]["albuns"]
                                  ["Use Your IIIlusion II"]["titulo"];
                              dados.ano = resultado["Guns N' Roses"]["albuns"]
                                      ["Use Your IIIlusion II"]["ano"]
                                  .toString();
                              dados.duracao = resultado["Guns N' Roses"]
                                          ["albuns"]["Use Your IIIlusion II"]
                                      ["duracao"]
                                  .toString();
                              dados.totalFaixas = resultado["Guns N' Roses"]
                                          ["albuns"]["Use Your IIIlusion II"]
                                      ["total-faixas"]
                                  .toString();
                              dados.nome = resultado["Guns N' Roses"]["nome"];
                              dados.object = "Use Your IIIlusion II.jpg";
                              dados.objectUpload = "useyour2/";
                            });
                            Navigator.pushNamed(context, "/detalhes",
                                arguments: dados);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
    );

  }
}
