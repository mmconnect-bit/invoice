// screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'productdialog.dart';
import '../../components/sidebar.dart';
import '../../components/topbar.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void showAddProductDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AddProductDialog(),
      );
    }

    final List<Map<String, String>> products = [
      {
        'name': 'bolt',
        'price': 'TND12,500.00',
        'code': '1234567',
        'unit': 'Kilo Gram',
        'category': 'Motorcycle accessories'
      },
      {
        'name': 'colddrink',
        'price': 'TND50.00',
        'code': '100001',
        'unit': 'Liter',
        'category': 'Hosted Server'
      },
      {
        'name': 'Talk show',
        'price': 'TND30,000.00',
        'code': 'ts',
        'unit': '-',
        'category': '-'
      },
      {
        'name': 'COAXIAL CABLE 100M',
        'price': 'TND65,000.00',
        'code': '593',
        'unit': 'Meter',
        'category': 'Electronics'
      },
      {
        'name': 'DVR 8 CHANNEL',
        'price': 'TND150,000.00',
        'code': '6978',
        'unit': 'Kilo Gram',
        'category': 'Electronics'
      },
      {
        'name': 'analog camera 2mp bullet',
        'price': 'TND35,000.00',
        'code': '693',
        'unit': 'Millimeter',
        'category': 'Electronics'
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopBar(),
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          // color: const Color.fromARGB(255, 220, 213, 213),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Product List',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showAddProductDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Add Product',
                              style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {}, child: const Text('Filter')),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () {}, child: const Text('Export')),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    textAlign:
                        TextAlign.center, // Centers text inside the search bar
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Code')),
                      DataColumn(label: Text('Unit')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: products.map((product) {
                      return DataRow(cells: [
                        DataCell(Text(product['name']!)),
                        DataCell(Text(product['price']!)),
                        DataCell(Text(product['code']!)),
                        DataCell(Text(product['unit']!)),
                        DataCell(Text(product['category']!)),
                        const DataCell(Icon(Icons.more_vert)),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
