import 'package:admin/controllers/home-widget-controller.dart';
import 'package:admin/models/product_list.dart';
import 'package:admin/repository/product-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class DeleteProductDialog extends StatelessWidget {
  final Product fileInfo;

  const DeleteProductDialog({Key? key, required this.fileInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    final HomeControllerWidget homeController = Get.put(HomeControllerWidget());
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
            productController.deleteProduct(fileInfo.id!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("${fileInfo.name} deleted!")),
            );
            homeController.onTab(3);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
