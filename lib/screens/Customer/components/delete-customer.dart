import 'package:admin/controllers/home-widget-controller.dart';
import 'package:admin/models/Invoice.dart';
import 'package:admin/models/customer.dart';
import 'package:admin/repository/customer-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class DeleteUserDialog extends StatelessWidget {
  final Customer fileInfo;

  const DeleteUserDialog({Key? key, required this.fileInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeControllerWidget homeController = Get.put(HomeControllerWidget());
    final CustomerController customerController = Get.put(CustomerController());
    return AlertDialog(
      title: const Text("Confirm Deletion"),
      content: Text("Are you sure you want to delete '${fileInfo.name}'?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            customerController.deleteCustomer(fileInfo.id!);
            homeController.onTab(5);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("${fileInfo.name} deleted!")),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
