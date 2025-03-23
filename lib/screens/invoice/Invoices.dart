import 'package:admin/controllers/home-widget-controller.dart';
import 'package:admin/repository/invoice-controller.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/invoice/components/delete-invoice.dart';
import 'package:admin/screens/invoice/components/download-pdf.dart';
import 'package:admin/screens/invoice/components/generate-invoice.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/Invoice.dart';
import 'package:admin/constants/constants.dart' as constant;
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Invoices extends StatefulWidget {
  const Invoices({Key? key}) : super(key: key);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  int _rowsPerPage = 10;
  final InvoiceController invoiceController = Get.put(InvoiceController());
  final HomeControllerWidget homeController = Get.put(HomeControllerWidget());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Invoices",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: constant.defaultPadding * 1.5,
                  vertical: constant.defaultPadding / 2,
                ),
                minimumSize: Size(0, 60),
              ),
              onPressed: () {
                homeController.onTab(2);
              },
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(height: 10),
        SearchField(),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 20,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<List<Invoice>>(
                    future: invoiceController.fetchInvoices(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Center(child: CircularProgressIndicator()));
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No invoices found"));
                      } else {
                        final invoices = snapshot.data!;

                        return PaginatedDataTable(
                          header: Text("Invoice List"),
                          rowsPerPage: _rowsPerPage,
                          availableRowsPerPage: const [5, 10, 15],
                          onRowsPerPageChanged: (rows) {
                            if (rows != null) {
                              setState(() {
                                _rowsPerPage = rows;
                              });
                            }
                          },
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Invoice No')),
                            DataColumn(label: Text('Customer Name')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Address')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Actions')),
                          ],
                          source: InvoiceDataSource(context, invoices),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class InvoiceDataSource extends DataTableSource {
  final BuildContext context;
  final List<Invoice> invoices;

  InvoiceDataSource(this.context, this.invoices);

  @override
  DataRow? getRow(int index) {
    if (index >= invoices.length) return null;

    final invoice = invoices[index];
    final no = (index + 1).toString();

    final hasProduct = invoice.product.isNotEmpty;
    final productName = hasProduct ? invoice.product[0].name : "—";
    final productPrice = hasProduct
        ? invoice.product
            .fold(0.0, (sum, item) => sum + double.parse(item.price))
        : "0";

    return DataRow(cells: [
      DataCell(Text(no)),
      DataCell(Text(invoice.date)),
      DataCell(Text(invoice.invoiceNo)),
      DataCell(Text(invoice.customer.name)),
      DataCell(Text(invoice.customer.phone)),
      DataCell(Text(invoice.customer.address)),
      DataCell(Text(NumberFormat.currency(locale: 'en', symbol: 'TZS ')
          .format(productPrice))),
      DataCell(
        PopupMenuButton<String>(
          onSelected: (value) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (value == "delete") {
              showDialog(
                context: context,
                builder: (context) => DeleteInvoiceDialog(fileInfo: invoice),
              );
            } else if (value == "view") {
              int selectedIndex = 0;
              selectedIndex = prefs.getInt('selected_template') ?? 0;
              if (selectedIndex == 0) {
                generateInvoice(invoice);
              }
              if (selectedIndex == 1) {
                generateInvoiceTemplete2(invoice);
              }
            } else {
              int selectedIndex = 0;
              selectedIndex = prefs.getInt('selected_template') ?? 0;
              if (selectedIndex == 0) {
                downloadInvoiceTemplete1(invoice);
              }
              if (selectedIndex == 1) {
                downloadInvoiceTemplete2(invoice);
              }
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: "view",
              child: ListTile(
                leading: Icon(Icons.download_done,
                    color: Theme.of(context).primaryColor),
                title: Text("View"),
              ),
            ),
            PopupMenuItem(
              value: "download",
              child: ListTile(
                leading:
                    Icon(Icons.download, color: Theme.of(context).primaryColor),
                title: Text("Download"),
              ),
            ),
            PopupMenuItem(
              value: "delete",
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Delete"),
              ),
            ),
          ],
          icon: Icon(Icons.more_vert),
        ),
      ),
    ]);
  }

  @override
  int get rowCount => invoices.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
