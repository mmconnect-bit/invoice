import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String code;
  final String unit;
  final String category;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.code,
    required this.unit,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text('Price: $price'),
            Text('Code: $code'),
            Text('Unit: $unit'),
            Text('Category: $category'),
          ],
        ),
      ),
    );
  }
}
