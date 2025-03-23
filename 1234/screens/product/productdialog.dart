import 'package:flutter/material.dart';

class AddProductDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedUnit;
  String? selectedCategory;

  final List<String> units = ['Piece', 'Kilogram', 'Liter'];
  final List<String> categories = ['Electronics', 'Clothing', 'Accessories'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add product',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Name', nameController, isRequired: true),
            _buildTextField('Price', priceController,
                isRequired: true, keyboardType: TextInputType.number),
            _buildTextField('Code', codeController, isRequired: true),
            _buildDropdown('Unit', units, (value) => selectedUnit = value),
            _buildDropdown(
                'Category', categories, (value) => selectedCategory = value),
            _buildTextField('Description', descriptionController, maxLines: 3),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle form submission
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isRequired = false,
      TextInputType keyboardType = TextInputType.text,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (isRequired)
                const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            hint: Text('Choose a $label.toLowerCase()'),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
