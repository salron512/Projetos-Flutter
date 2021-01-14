import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minio/minio.dart';
import 'package:test_minio/Grid.dart';
import 'Dados.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minio/io.dart';

class Detalhes extends StatefulWidget {
  Dados dados;
  Detalhes(this.dados);
  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  // ignore: deprecated_member_use
  List<String> listaRecuperada = List<String>();
  String _carregadoImagem = "";
  String urlImagen;
  var reultado;
  final minio = Minio(
    port: 9000,
    endPoint: 'play.min.io',
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
    useSSL: true,
  );
  String _url;
  _consultaImagens() async {
    String bucket = "imagens-albuns";

    String url = await minio.presignedGetObject(bucket, widget.dados.object);

    setState(() {
      _url = url;
    });
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _consultaImagens();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes do Album"),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.blue),
          child: Center(

            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      child: _url == null
                          ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                          : Image.network(
                        _url,
                        alignment: Alignment.center,
                        height: 300,
                        width: 300,
                      ),
                      padding: EdgeInsets.all(8)),
                  Padding(
                    child: Text(
                      "Artista: " + widget.dados.nome,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Padding(
                      child: Text(
                        "Album: " + widget.dados.album,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: EdgeInsets.only(top: 8)),
                  Padding(
                    child: Text(
                      "Ano de lançamento: " + widget.dados.ano,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Padding(
                    child: Text(
                      "Duração: " + widget.dados.duracao +" minutos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Padding(
                    child: Text(
                      "Total faixas: " + widget.dados.totalFaixas,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Padding(padding: EdgeInsets.all(8),
                    child: RaisedButton(
                        child: Text("Ver Galeria",
                        style: TextStyle(
                          color: Colors.white
                        ),
                        ),
                        color: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed:(){
                          Navigator.pushNamed(context, "/grid", arguments: widget.dados);
                        }

                    ),
                  ),
                  Text(_carregadoImagem),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
