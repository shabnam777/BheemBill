// lib/utils/bill_pdf_generator.dart
import 'package:billing_app/models/bill_item.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillPdfGenerator {
  static Future<void> generateAndOpen({required BillItem billItem}) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('INVOICE',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 12),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(2),
                },
                children: [
                  _tableRow('Party Name', billItem.partyName),
                  _tableRow('Weft Name / Qty', billItem.weftName),
                  _tableRow('Set No.', billItem.setNo),
                  _tableRow('Rate', billItem.rate.toStringAsFixed(2)),
                  _tableRow('Total Consumption', billItem.totalConsumption.toStringAsFixed(2)),
                  _tableRow('Per Cut', billItem.perCut.toStringAsFixed(2)),
                  _tableRow('Pagar', billItem.pagar.toStringAsFixed(2)),
                  _tableRow('Total Dori', billItem.totalDori.toStringAsFixed(2)),
                  _tableRow('Zyada Bacha', billItem.zyadaBacha.toStringAsFixed(2)),
                  _tableRow('Dori', billItem.dori.toStringAsFixed(2)),
                  _tableRow('Total Cut', billItem.totalCut.toStringAsFixed(2)),
                  _tableRow('Final Amount', billItem.finalAmount.toStringAsFixed(2)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Grand Total: Rs. ${billItem.total.toStringAsFixed(0)}',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await doc.save();
    await Printing.sharePdf(bytes: bytes, filename: 'Bill_${billItem.setNo}.pdf');
  }

  static pw.TableRow _tableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 11)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}