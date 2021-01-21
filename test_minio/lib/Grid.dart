import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'Dados.dart';

class Grid extends StatefulWidget {
  Dados dados;
  Grid(this.dados);
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  String _mensagem = "Sem imagens do album no momento!";
  String _carregadoImagem = "";
  // ignore: deprecated_member_use
  List<String> listaRecuperada = List();
  final minio = Minio(
    port: 9000,
    endPoint: 'play.min.io',
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
    useSSL: true,
  );

  Future _recuperaGrid() async {
    print("dados pasta: " + widget.dados.objectUpload);
    listaRecuperada.clear();
    String bucket = "imagens-albuns";
    await minio
        .listObjectsV2(bucket, prefix: widget.dados.objectUpload)
        .forEach((chunk) async {
      var verificaRetorno = chunk.objects;
      chunk.objects.forEach((o) {
        print("cconsultado bucket" + o.key);
      });
      if (verificaRetorno.isNotEmpty) {
        for (int i = 0; i < verificaRetorno.length; i++) {
          print("FOR " + verificaRetorno[i].key);

          String url = await minio.presignedGetObject(
              bucket, verificaRetorno[i].key);

          print("url Imagens " + url);
          listaRecuperada.add(url);
        }
      }
    }
      );
     return listaRecuperada;
  }

  _recuperaImagem() async {
    final picker = ImagePicker();
    String bucket = "imagens-albuns";

    var imagemRecuperada = await picker.getImage(source: ImageSource.gallery);
    var url = imagemRecuperada.path;
    print(bucket + url);
    String object = widget.dados.objectUpload +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".jpg";
    if (url.isNotEmpty) {
      int size = url.length;
      MinioInvalidBucketNameError.check(bucket);
      MinioInvalidObjectNameError.check(object);
      minio.fPutObject(bucket, object, url).then((estado) {
        print("estado " + estado);
        setState(() {});
      }).whenComplete(() {
        print("Carregamento da imagens completo");
      }).catchError((erro) {
        setState(() {
          _carregadoImagem = "erro ao carregar";
        });
      });
    }
  }

  // ignore: deprecated_member_use
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listaRecuperada.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galeria"),
      ),
      body: FutureBuilder(
        future: _recuperaGrid(),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ));
              break;
            case ConnectionState.active:
            case ConnectionState.done:
            List<String> item = snapshot.data;
              if (item.isNotEmpty) {
                return Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    padding: EdgeInsets.all(8),
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: List.generate(
                          // ignore: missing_return
                          item.length, (indice) {
                        return Image.network(
                          item[indice],
                          width: 100,
                          height: 100,
                        );
                      }),
                    ));
              } else {
                return Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text(_mensagem,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    ),
                  ),
                );
              }
              break;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),
        onPressed: () {
           _recuperaImagem();
        },
      ),
    );
  }
}