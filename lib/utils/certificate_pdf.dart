import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificatePDF {
  static Future<void> generate(String fullName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(32),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 3),
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "CERTIFICADO DE APROBACIÓN",
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Text("LudiARTech", style: pw.TextStyle(fontSize: 26)),
              pw.SizedBox(height: 20),
              pw.Text(
                "Otorga el presente certificado",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 18),
              ),
              pw.Text(
                fullName,
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Por haber completado y aprobado satisfactoriamente todas las lecciones...",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 40),
              pw.Text("🎓", style: const pw.TextStyle(fontSize: 60)),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
