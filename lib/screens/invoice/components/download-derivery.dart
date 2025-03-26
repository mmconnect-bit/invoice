import 'dart:io';
import 'package:admin/constants/constants.dart';
import 'package:admin/models/Invoice.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

Future<void> saveInvoiceToLocal(pw.Document pdf, String invoiceName) async {
  Directory? downloadsDir;

  try {
    if (Platform.isWindows || Platform.isLinux) {
      downloadsDir = await getDownloadsDirectory();
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    final invoicesDir = Directory("${downloadsDir!.path}/Invoices");

    if (!await invoicesDir.exists()) {
      await invoicesDir.create(recursive: true);
    }

    final filePath = "${invoicesDir.path}/$invoiceName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("✅ Invoice saved to: $filePath");
    OpenFilex.open(file.path); // Optional: Opens file after saving
  } catch (e) {
    print("❌ Error saving invoice: $e");
  }
}

const PdfColor primaryColor = PdfColors.blueGrey900;
const PdfColor secondaryColor = PdfColors.blue;
const PdfColor textColor = PdfColors.white;

Future<void> downloadDeriveryNote(Invoice invoice) async {
  final pdf = pw.Document();
  final logo2 =
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
  final logo =
      (await rootBundle.load('assets/images/logo1.png')).buffer.asUint8List();
  double totalPrice = invoice.product.fold(0, (sum, product) {
    double price = double.tryParse(product.price) ?? 0;
    return sum + price;
  });
  final grouped = groupBy(invoice.product, (p) => p);
  final uniqueProducts = grouped.entries.toList();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Container(
            padding: pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: pdfColors, width: 2),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(pw.MemoryImage(logo2), width: 80),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("AMOS INVESTMENT CO.LTD",
                            style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blueGrey900)),
                        pw.Text("P.O.BOX 784, SUMBAWANGA, LUKWA"),
                        pw.Text("PHONE: 0756 994581 / 0787 700333"),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Title
                pw.Text("DELIVERY NOTE",
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: pdfColors,
                    )),
                pw.Divider(),

                // Customer and Delivery Info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Delivery To: ${invoice.customer.name}"),
                        pw.Text("Phone: ${invoice.customer.phone}"),
                        pw.Text("Address: ${invoice.customer.address}"),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Date: ${invoice.date}"),
                        pw.Text("Invoice No: ${invoice.invoiceNo}"),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Items Table
                pw.Table.fromTextArray(
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  headerDecoration: pw.BoxDecoration(color: pdfColors),
                  headers: [
                    "#",
                    "Item Description",
                    "unit",
                    "Qty",
                    "Unit price",
                    "Total"
                  ],
                  cellAlignment: pw.Alignment.centerLeft,
                  data: List<List<String>>.generate(
                    uniqueProducts.length,
                    (index) {
                      final entry = uniqueProducts[index];
                      final product = entry.key;
                      final quantity = entry.value.length;

                      final unitPrice = double.tryParse(product.price) ?? 0;
                      final total = (unitPrice * quantity);

                      return [
                        "${index + 1}",
                        product.name,
                        product.unit,
                        "$quantity",
                        "${NumberFormat.currency(locale: 'en', symbol: '').format(unitPrice)}",
                        " ${NumberFormat.currency(locale: 'en', symbol: '').format(total)}",
                      ];
                    },
                  ),
                  border: pw.TableBorder.all(color: PdfColors.grey),
                ),
                pw.SizedBox(
                  height: 20,
                ),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                      "Total: ${NumberFormat.currency(locale: 'en', symbol: 'TZS ').format(totalPrice)} ",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 18,
                          color: PdfColor.fromInt(0x00000000))),
                ),

                pw.SizedBox(height: 40),

                // Signature section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text("Delivered By"),
                        pw.SizedBox(height: 40),
                        pw.Text("_____________________"),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text("Received By"),
                        pw.SizedBox(height: 40),
                        pw.Text("_____________________"),
                      ],
                    ),
                  ],
                ),
              ],
            ));
      },
    ),
  );
  await saveInvoiceToLocal(
      pdf, "${invoice.customer.name}_${invoice.invoiceNo}");
}
