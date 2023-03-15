import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final username = 'andre.vicensotti@gmail.com';
  final password = 'alphatkmriljekba';
  String _msg = '';
  bool _carregando = false;
  Future _enviaEmail() async {
    final smtpServer = gmail(username, password);

    setState(() {
      _msg = 'Enviando email...!';
    });

    final message = Message()
      ..from = Address(username, 'Your name 😀')
      ..recipients.add(Address('andre.vicensotti@gmail.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..attachments = [
        FileAttachment(File('C:\\Users\\Usuario\\Documents\\out.zip')),
      ];

    try {
      final sendReport = await send(message, smtpServer);
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
