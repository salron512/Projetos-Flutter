import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minio/minio.dart';
import 'package:test_minio/Detalhes.dart';
import 'dart:convert';
import 'Dados.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Dados dados = Dados();
  var passadadosAlbum;
  var passadadosNome;
  String _url = "";
  var resultado;
  int index;
  _consulta() async {
    String url = "https://lista-albuns-default-rtdb.firebaseio.com/artista.json";

    http.Response response = await http.get(url);
    setState(() {
      resultado = jsonDecode(response.body);
    });
    print("Status: " + response.statusCode.toString());
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
      body: resultado == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Serj tankian"]["album1"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Serj tankian"]["nome"].toString()),
                      onTap: () {
                        setState((){
                          dados.album = resultado["Serj tankian"]["album1"];
                          dados.nome = resultado["Serj tankian"]["nome"];
                            dados.object = "perfil_Harakiri.jpg";
                            dados.objectUpload = "/Harakiri/";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Serj tankian"]["album2"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Serj tankian"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Serj tankian"]["album2"];
                          dados.nome = resultado["Serj tankian"]["nome"];
                          dados.object = "black-blooms.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Serj tankian"]["album3"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Serj tankian"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Serj tankian"]["album3"];
                          dados.nome = resultado["Serj tankian"]["nome"];
                          dados.object = "trd.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Mike Shinoda"]["album1"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Mike Shinoda"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Mike Shinoda"]["album1"];
                          dados.nome = resultado["Mike Shinoda"]["nome"];
                          dados.object = "The Rising Tied.jpeg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Mike Shinoda"]["album2"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Mike Shinoda"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Mike Shinoda"]["album2"];
                          dados.nome = resultado["Mike Shinoda"]["nome"];
                          dados.object ="post traumatic.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Mike Shinoda"]["album3"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Mike Shinoda"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Mike Shinoda"]["album3"];
                          dados.nome = resultado["Mike Shinoda"]["nome"];
                          dados.object = 'Post_Traumatic_EP.jpg';
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Mike Shinoda"]["album4"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Mike Shinoda"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Mike Shinoda"]["album4"];
                          dados.nome = resultado["Mike Shinoda"]["nome"];
                          dados.object = "where.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Michel Teló"]["album1"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Michel Teló"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Michel Teló"]["album1"];
                          dados.nome = resultado["Michel Teló"]["nome"];
                          dados.object = "bem_sertanejo.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Michel Teló"]["album2"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Michel Teló"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Michel Teló"]["album2"];
                          dados.nome = resultado["Michel Teló"]["nome"];
                          dados.object = "bem_sertanejo_aovivo.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Michel Teló"]["album3"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Michel Teló"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Michel Teló"]["album3"];
                          dados.nome = resultado["Michel Teló"]["nome"];
                          dados.object = "bem_sertanejo_EP.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Guns N' Roses"]["album1"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Guns N' Roses"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Guns N' Roses"]["album1"];
                          dados.nome = resultado["Guns N' Roses"]["nome"];
                          dados.object = "Use Your IIIlusion I.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Guns N' Roses"]["album2"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Guns N' Roses"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Guns N' Roses"]["album3"];
                          dados.nome = resultado["Guns N' Roses"]["nome"];
                          dados.object = "Use Your IIIlusion II.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Album: " +
                          resultado["Guns N' Roses"]["album3"].toString()),
                      subtitle: Text("Artista: " +
                          resultado["Guns N' Roses"]["nome"].toString()),
                      onTap: (){
                        setState(() {
                          dados.album = resultado["Guns N' Roses"]["album3"];
                          dados.nome = resultado["Guns N' Roses"]["nome"];
                          dados.object = "Greatest_Hits.jpg";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detalhes(dados)
                            )
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
