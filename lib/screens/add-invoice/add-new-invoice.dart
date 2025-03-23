import 'package:admin/constants/constants.dart';
import 'package:admin/controllers/home-widget-controller.dart';
import 'package:admin/models/Invoice.dart';
import 'package:admin/models/customer.dart';
import 'package:admin/models/product_list.dart';
import 'package:admin/repository/customer-controller.dart';
import 'package:admin/repository/invoice-controller.dart';
import 'package:admin/repository/product-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInvoicePage extends StatefulWidget {
  @override
  _AddInvoicePageState createState() => _AddInvoicePageState();
}

class _AddInvoicePageState extends State<AddInvoicePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController customerController = TextEditingController();
  final CustomerController dbController = Get.put(CustomerController());
  final ProductController productController = Get.put(ProductController());
  final InvoiceController invoiceController = Get.put(InvoiceController());
  final HomeControllerWidget homeController = Get.put(HomeControllerWidget());

  Customer? selectedCustomer;
  Map<Product, int> selectedProductsWithQuantity = {};
  List<Product> products = [];
  bool _isEmptyData = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    customerController.dispose();
    super.dispose();
  }

  Future<List<Customer>> fetchCustomers(String query, customers) async {
    return customers
        .where((customer) =>
            customer.name.toLowerCase().contains(query.toLowerCase()) ||
            customer.phone.contains(query))
        .toList();
  }

  Future<void> _loadMoreProducts() async {
    List<Product> data = await productController.fetchProducts();
    setState(() {
      products.addAll(data);
    });
  }

  void _submitInvoice() async {
    if (selectedProductsWithQuantity.isNotEmpty && selectedCustomer != null) {
      List<Product> selectedProducts = selectedProductsWithQuantity.entries
          .expand((entry) => List.filled(entry.value, entry.key))
          .toList();

      Invoice newInvoice = Invoice(
        invoiceNo: "",
        customer: selectedCustomer!,
        product: selectedProducts,
        date: "",
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Please wait..."),
              ],
            ),
          );
        },
      );

      invoiceController.createInvoiceproduct(newInvoice).then((val) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);

          homeController.onTab(4);
        });
      });
      customerController.clear();
      setState(() {
        selectedCustomer = null;
        selectedProductsWithQuantity.clear();
      });
    } else {
      setState(() {
        _isEmptyData = true;
      });
    }
  }

  void refresh() {
    setState(() {});
  }

  void _openProductDialog(BuildContext context) {
    List<Product> _tempFiltered = List.from(products);
    TextEditingController _searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Products"),
                  SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Search Product",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _tempFiltered = products.where((product) {
                          return product.name
                                  .toLowerCase()
                                  .contains(query.toLowerCase()) ||
                              product.code
                                  .toLowerCase()
                                  .contains(query.toLowerCase());
                        }).toList();
                      });
                    },
                  ),
                ],
              ),
              content: Container(
                width: 700,
                height: 400,
                child: ListView(
                  children: _tempFiltered.map((product) {
                    final isSelected =
                        selectedProductsWithQuantity.containsKey(product);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(
                        "${product.name} - TZS ${NumberFormat.currency(locale: 'en', symbol: '').format(double.parse(product.price))}",
                      ),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            selectedProductsWithQuantity.putIfAbsent(
                                product, () => 1);
                          } else {
                            selectedProductsWithQuantity.remove(product);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    refresh();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 17, 16, 87), // 👈 Set background color
                    padding: EdgeInsets.symmetric(
                      // 👈 Increase padding for width/height
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: FutureBuilder<List<Customer>>(
              future: dbController.fetchCustomers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No invoices found"));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text("Select Customer"),
                      TypeAheadField<Customer>(
                        controller: customerController,
                        suggestionsCallback: (pattern) async {
                          return await fetchCustomers(pattern, snapshot.data);
                        },
                        itemBuilder: (context, Customer suggestion) {
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text(suggestion.name),
                            subtitle: Text(suggestion.phone),
                          );
                        },
                        onSelected: (Customer suggestion) {
                          setState(() {
                            selectedCustomer = suggestion;
                            customerController.text = suggestion.name;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Select Products"),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _openProductDialog(context),
                        child: Text("Choose Products"),
                      ),
                      SizedBox(height: 20),
                      if (selectedProductsWithQuantity.isNotEmpty)
                        Column(
                          children:
                              selectedProductsWithQuantity.entries.map((entry) {
                            Product product = entry.key;
                            int quantity = entry.value;

                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(product.name),
                                subtitle: Text("Quantity: $quantity"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        setState(() {
                                          if (quantity > 1) {
                                            selectedProductsWithQuantity[
                                                product] = quantity - 1;
                                          } else {
                                            selectedProductsWithQuantity
                                                .remove(product);
                                          }
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        setState(() {
                                          selectedProductsWithQuantity[
                                              product] = quantity + 1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      SizedBox(height: 10),
                      if (_isEmptyData && selectedProductsWithQuantity.isEmpty)
                        Text(
                          "Select customer and  atleast one product",
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: _submitInvoice,
                          icon: Icon(Icons.create, color: Colors.white),
                          label: Text("Generate Invoice"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
