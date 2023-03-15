import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  TextEditingController _controllerEmailContabilidade = TextEditingController();
  String _pathNfce = '';
  String _pathNfe = '';
  bool _nfe = false;
  bool _nfce = false;

  Future<void> _recuperaConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nfce = prefs.getBool('nfce') ?? false;
      _nfe = prefs.getBool('nfe') ?? false;
      _pathNfce = prefs.getString('pathNfce') ?? '';
      _pathNfe = prefs.getString('pathNfe') ?? '';
      _controllerEmailContabilidade.text = prefs.getString('emailCont') ?? '';
    });
  }

  Future<void> _recuperaPathNfe() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        _pathNfe = selectedDirectory;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pathNfe', _pathNfe);
      await prefs.setBool('nfe', true);
    }
  }

  Future<void> _recuperaPathNfce() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        _pathNfce = selectedDirectory;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pathNfce', _pathNfe);
      await prefs.setBool('nfce', true);
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperaConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5, top: 20),
              child: SizedBox(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _controllerEmailContabilidade,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                      // hintText: "E-mail",
                      label: const Text('Email contabilidade'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            Card(
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _nfe,
                onChanged: (value) {
                  setState(() {
                    _nfe = value!;
                  });

                  if (value!) {
                    _recuperaPathNfe();
                  }
                },
                title: const Text('Caminho pasta NFe'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 5, top: 20),
                  child: SizedBox(
                      width: 250,
                      child: Text(
                        _pathNfe,
                        style: const TextStyle(fontSize: 10),
                      )),
                ),
              ),
            ),
            Card(
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _nfce,
                onChanged: (value) {
                  setState(() {
                    _nfce = value!;
                  });
                  if (value!) {
                    _recuperaPathNfce();
                  }
                },
                title: const Text('Caminho pasta NFCe'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 5, top: 20),
                  child: SizedBox(
                      width: 250,
                      child: Text(
                        _pathNfce,
                        style: const TextStyle(fontSize: 10),
                      )),
                ),
              ),
            ),
            Expanded(child: Container()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Salvar'),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
