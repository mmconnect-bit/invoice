import 'package:admin/models/Invoice.dart';
import 'package:admin/models/customer.dart';
import 'package:admin/models/product_list.dart';
import 'package:admin/repository/database-helper.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class InvoiceController extends GetxController {
  List<Invoice> invoices = [];

  @override
  void onInit() {
    super.onInit();

    fetchInvoices();
  }

  DBHelper dbHelper = DBHelper.instance;

  Future<void> createInvoiceproduct(Invoice invoice) async {
    Database db = await dbHelper.database;
    createInvoice(invoice).then((val) async {
      for (int i = 0; i < invoice.product.length; i++) {
        await db.insert("InvoiceProducts",
            {"invoice_id": val, "product_id": invoice.product[i].id});
      }
    });
  }

  Future<int> createInvoice(Invoice invoice) async {
    final invoiceNo = generateShortInvoiceNo();
    final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    Database db = await dbHelper.database;
    return await db.insert("Invoices", {
      "invoiceNo": invoiceNo,
      "customer_id": invoice.customer.id,
      "date": formattedDate, // 👈 insert formatted current date
    });
  }

  Future<List<Invoice>> fetchInvoices() async {
    final db = await dbHelper.database;
    final invoiceRows = await db.query(
      "Invoices",
      orderBy: "id DESC",
    );

    List<Invoice> invoices = [];

    for (final row in invoiceRows) {
      // 1. Check for customer
      final customerResult = await db.query(
        "Customers",
        where: "id = ?",
        whereArgs: [row["customer_id"]],
      );

      if (customerResult.isEmpty) {
        print("Missing customer for invoice: ${row["invoiceNo"]}");
        continue; // Skip this invoice
      }

      final Customer customer = Customer.fromMap(customerResult.first);

      // 2. Fetch product links
      final invoiceProductRows = await db.query(
        "InvoiceProducts",
        where: "invoice_id = ?",
        whereArgs: [row["id"]],
      );

      List<Product> products = [];
      for (final invoiceProduct in invoiceProductRows) {
        final productResult = await db.query(
          "Products",
          where: "id = ?",
          whereArgs: [invoiceProduct["product_id"]],
        );

        if (productResult.isNotEmpty) {
          products.add(Product.fromMap(productResult.first));
        } else {
          print("Missing product with ID: ${invoiceProduct["product_id"]}");
        }
      }

      invoices.add(Invoice(
        id: row["id"] as int,
        invoiceNo: row["invoiceNo"]?.toString() ?? '',
        customer: customer,
        product: products,
        date: row["date"]?.toString() ?? '',
      ));
    }

    return invoices;
  }

  Future<int> deleteInvoice(int id) async {
    Database db = await dbHelper.database;
    int id1 = await db.delete("Invoices", where: "id = ?", whereArgs: [id]);
    return await db
        .delete("InvoiceProducts", where: "invoice_id = ?", whereArgs: [id1]);
  }

  String generateShortInvoiceNo() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final short = now % 10000000;
    return '${short.toString().padLeft(6, '0')}';
  }
}
