import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final username = 'andre.vicensotti@gmail.com';
  final password = 'alphatkmriljekba';
  final TextEditingController _controllerEmail = TextEditingController();
  String _msg = '';
  bool _carregando = false;
  Future _enviaEmail() async {
    final smtpServer = gmail(username, password);

    setState(() {
      _msg = 'Enviando email...!';
    });
    String emailDestinatario = _controllerEmail.text;
    final message = Message()
      ..from = Address(username, 'Your name 😀')
      ..recipients.add(Address(emailDestinatario))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..attachments = [
        FileAttachment(File('C:\\Users\\Usuario\\Documents\\out.zip')),
      ];

    try {
      await send(message, smtpServer);
      setState(() {
        _carregando = false;
        _msg = 'Email enviado!';
      });
    } on MailerException catch (e) {
      setState(() {
        _carregando = false;
        _msg = 'Email não enviado!';
      });
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
        setState(() {
          _msg = 'Erro: ${p.code}: ${p.msg}';
        });
      }
    }
  }

  void _zipar() async {
    setState(() {
      _carregando = true;
      _msg = 'Gerando arquivo...!';
    });
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(Directory('C:\\Users\\Usuario\\Documents\\teste'),
        filename: 'C:\\Users\\Usuario\\Documents\\out.zip');
    setState(() {
      _carregando = true;
      _msg = 'Arquivo Gerado...!';
    });
    _enviaEmail();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: _carregando,
                    child: const CircularProgressIndicator()),
                Center(
                  child: Text(
                    _msg,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5, top: 20),
              child: SizedBox(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _controllerEmail,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Enviar arquivos',
        onPressed: _zipar,
        child: const Icon(
          Icons.send_sharp,
          color: Colors.white,
        ),
      ),
    );
  }
}
