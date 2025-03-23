import 'package:admin/controllers/home-widget-controller.dart';
import 'package:admin/repository/product-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class AddProductDialog extends StatefulWidget {
  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final ProductController productController = Get.put(ProductController());
  final HomeControllerWidget homeController = Get.put(HomeControllerWidget());
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth =
        MediaQuery.of(context).size.width * 0.5; // Half screen width

    return AlertDialog(
      title: const Text("Add Product"),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Name", nameController),
              _buildTextField("Price", priceController),
              _buildTextField("Code", codeController),
              _buildTextField("Unit", unitController),
              _buildTextField("Category", categoryController),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            productController.createProduct({
              "icon": "",
              "name": nameController.text,
              "price": priceController.text,
              "code": codeController.text,
              "unit": unitController.text,
              "category": categoryController.text,
            });
            productController.fetchProducts();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("${nameController.text} created!")),
            );
            homeController.onTab(3);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
