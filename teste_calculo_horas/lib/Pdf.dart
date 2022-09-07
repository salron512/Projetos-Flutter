import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class Pdf {
  Future<void> testePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(children: []),
        ),
      ),
    );

    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());
    file.create();
  }
}
