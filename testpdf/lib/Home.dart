import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  _testPdf() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        }));
    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save()); // Page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("teste"),
          onPressed: () {
            _testPdf();
          },
        ),
      ),
    );
  }
}
