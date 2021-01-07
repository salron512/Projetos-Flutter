import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:minio/minio.dart';
import 'package:minio/io.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:test_minio/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _pegaImagem() async {
    var pegaImagem = ImagePicker();

    var imagem = await pegaImagem.getImage(source: ImageSource.gallery);

    File imagemRecuperado;

    setState(() {
      imagemRecuperado = File(imagem.path);
    });
    print("Resultado " + imagemRecuperado.path);

    final minio = Minio(
        endPoint: "play.min.io",
        accessKey: "Q3AM3UQ867SPQQA43P2F",
        secretKey: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG",
        port: 9000,
        useSSL: true);
    final bucket = "testeandre";
    String pasta = "teste/";
    String nome = DateTime.now().microsecondsSinceEpoch.toString();
    final object = "$pasta$nome.jpg";
    if (!await minio.bucketExists(bucket)) {
      await minio.makeBucket(bucket);
      print('bucket criado');
    } else {
      print("bucket já existe");
    }

    int size = await imagemRecuperado.length();

    assert(size >= 0 || size == null);
    MinioInvalidBucketNameError.check(bucket);
    MinioInvalidObjectNameError.check(object);

    minio.fPutObject(bucket, object, imagemRecuperado.path).then((value) {
      print("subindo arquivo");
    }).catchError((erro) {
      print("erro");
    });
    final url = await minio.presignedGetObject(bucket, object, expires: 1000);
    print('--- presigned url:' + url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Albuns")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("Album: Harakiri"),
                subtitle: Text("Artista: Serj tankian"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Album: Black Blooms"),
                subtitle: Text("Artista: Serj tankian"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Album: The Rough Dog"),
                subtitle: Text("Artista: Serj tankian"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  "Album: The Rising Tied",
                ),
                subtitle: Text("Mike Shinoda"),
              ),
            ),
            RaisedButton(
                child: Text("upload"),
                onPressed: () {
                  _pegaImagem();
                })
          ],
        ),
      ),
    );
  }
}
