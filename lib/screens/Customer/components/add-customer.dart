import 'package:admin/controllers/home-widget-controller.dart';
import 'package:admin/repository/customer-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class AddUSerDialog extends StatefulWidget {
  @override
  _AddUSerDialogState createState() => _AddUSerDialogState();
}

class _AddUSerDialogState extends State<AddUSerDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final CustomerController dbController = Get.put(CustomerController());
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
    double dialogWidth = MediaQuery.of(context).size.width * 0.5;
    return AlertDialog(
      title: const Text("Add Customer"),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Name", nameController),
              _buildTextField("Phone", phoneController),
              _buildTextField("email", emailController),
              _buildTextField("Address", addressController),
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
            final respose = dbController.createCustomer({
              "icon": "",
              "name": nameController.text,
              "phone": phoneController.text,
              "email": emailController.text,
              "address": addressController.text,
            });
            homeController.onTab(5);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("${nameController.text} created!")),
            );
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
