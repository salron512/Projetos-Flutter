import 'dart:io';
import 'dart:html' as webFile;
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    /*
    //FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (kIsWeb) {
      final webFile.File file = await webPicker.FilePicker.getFile();
      String caminho = await file.relativePath.toString();
      print("caminho " + caminho);

      final reader = webFile.FileReader();
      reader.readAsText(file);

      await reader.onLoad.first;

      var data = reader.result;
      print('Resultado: ' + data.toString());
    }

    
    if (result != null) {
      var file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.identifier);
      print(file.path.toString());

      var arquivo = await File(file.path.toString()).openRead();

    */
    var csvFile = await FilePicker.platform.pickFiles(
        allowedExtensions: ['csv'],
        type: FileType.custom,
        allowMultiple: false);
    //decode bytes back to utf8
    final csv = utf8.decode(csvFile.files[0].bytes);
    List<List<dynamic>> linhas =
        const CsvToListConverter(fieldDelimiter: ';').convert(csv).toList();

    for (var linha in linhas) {
      var nome = linha[0];
      var telefone = linha[1];
      var cidade = linha[2];

      print('nome: $nome, telefone: $telefone, cidade: $cidade');
    }

    // User canceled the picker
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
