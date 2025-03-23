import 'package:admin/repository/product-controller.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/product_list.dart';
import 'package:admin/constants/constants.dart' as constant;
import 'package:admin/screens/product/components/add-product.dart';
import 'package:admin/screens/product/components/delete-product.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  int _rowsPerPage = 10;

  final ProductController productController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Products",
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
                showDialog(
                  context: context,
                  builder: (context) => AddProductDialog(),
                );
              },
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(height: 10),
        SearchField(),
        SizedBox(height: 10),
        FutureBuilder<List<Product>>(
            future: productController.fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No Product found"));
              } else {
                return Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // shadow color
                        spreadRadius: 4, // how far the shadow spreads
                        blurRadius: 20, // blur softness
                        offset: Offset(0, 0), // equal shadow on all sides
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: PaginatedDataTable(
                          header: Text("Product List"),
                          rowsPerPage: _rowsPerPage,
                          availableRowsPerPage: [5, 10, 15],
                          onRowsPerPageChanged: (rows) {
                            if (rows != null) {
                              setState(() {
                                _rowsPerPage = rows;
                              });
                            }
                          },
                          columns: [
                            DataColumn(
                              label: Text('#'),
                            ),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Code')),
                            DataColumn(label: Text('Unit')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Actions')),
                          ],
                          source: ProductDataSource(context, snapshot.data!),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ],
    );
  }
}

class ProductDataSource extends DataTableSource {
  final BuildContext context;
  final List<Product> products;

  ProductDataSource(this.context, this.products);

  @override
  DataRow getRow(int index) {
    if (index >= products.length) return null as DataRow;

    final product = products[index];
    final no = (index + 1).toString();
    return DataRow(cells: [
      DataCell(Text(no)),
      DataCell(Text(product.name)),
      DataCell(Text(NumberFormat.currency(locale: 'en', symbol: 'TZS ')
          .format(double.parse(product.price)))),
      DataCell(Text(product.code)),
      DataCell(Text(product.unit)),
      DataCell(Text(product.category)),
      DataCell(
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "edit") {
              _showEditDialog(context, product);
            } else if (value == "delete") {
              showDialog(
                context: context,
                builder: (context) => DeleteProductDialog(fileInfo: product),
              );
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: "edit",
              child: ListTile(
                leading:
                    Icon(Icons.edit, color: Theme.of(context).primaryColor),
                title: Text("Edit"),
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
  int get rowCount => products.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  void _showEditDialog(BuildContext context, Product product) {
    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price);
    TextEditingController codeController =
        TextEditingController(text: product.code);
    TextEditingController unitController =
        TextEditingController(text: product.unit);
    TextEditingController categoryController =
        TextEditingController(text: product.category);

    final ProductController productController = Get.put(ProductController());

    showDialog(
      context: context,
      builder: (context) {
        double dialogWidth = MediaQuery.of(context).size.width * 0.5;

        Widget _buildTextField(String label, TextEditingController controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          );
        }

        return AlertDialog(
          title: const Text("Edit Product"),
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
                productController.updateProduct(product.id!, {
                  "icon": "",
                  "name": nameController.text,
                  "price": priceController.text,
                  "code": codeController.text,
                  "unit": unitController.text,
                  "category": categoryController.text,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${nameController.text} updated!")),
                );
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
