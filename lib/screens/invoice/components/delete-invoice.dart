import 'package:admin/controllers/home-widget-controller.dart';
import 'package:admin/models/Invoice.dart';
import 'package:admin/repository/invoice-controller.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteInvoiceDialog extends StatefulWidget {
  final Invoice fileInfo;

  const DeleteInvoiceDialog({Key? key, required this.fileInfo})
      : super(key: key);

  @override
  State<DeleteInvoiceDialog> createState() => _DeleteInvoiceDialogState();
}

class _DeleteInvoiceDialogState extends State<DeleteInvoiceDialog> {
  final InvoiceController invoiceController = Get.put(InvoiceController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerWidget>(
        builder: (controller) => AlertDialog(
              title: const Text("Confirm Deletion"),
              content: Text(
                  "Are you sure you want to delete '${widget.fileInfo.invoiceNo}'?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    invoiceController.deleteInvoice(widget.fileInfo.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content:
                              Text("${widget.fileInfo.invoiceNo} deleted!")),
                    );
                    controller.onTab(4);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            ));
  }
}
