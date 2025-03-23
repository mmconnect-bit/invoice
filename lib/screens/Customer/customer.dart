import 'package:admin/controllers/home-widget-controller.dart';
import 'package:admin/repository/customer-controller.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/customer.dart';
import 'package:admin/constants/constants.dart' as constant;
import 'package:admin/screens/Customer/components/add-customer.dart';
import 'package:admin/screens/Customer/components/delete-customer.dart';
import 'package:get/instance_manager.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  int _rowsPerPage = 10;
  int _currentPage = 0;
  final CustomerController customerController = Get.put(CustomerController());

  @override
  void initState() {
    customerController.fetchCustomers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Customers",
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
                  builder: (context) => AddUSerDialog(),
                ).then((_) {
                  setState(() {
                    customerController.fetchCustomers();
                  });
                });
              },
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(height: 10),
        SearchField(),
        SizedBox(height: 10),
        Container(
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
            child: FutureBuilder<List<Customer>>(
                future: customerController.fetchCustomers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No Customer found"));
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PaginatedDataTable(
                            header: Text("Customer List"),
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
                              DataColumn(label: Text('#')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Phone')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Address')),
                              DataColumn(label: Text('Actions')),
                            ],
                            source: CustomerDataSource(context, snapshot.data!),
                          ),
                        ),
                      ],
                    );
                  }
                })),
      ],
    );
  }
}

class CustomerDataSource extends DataTableSource {
  final BuildContext context;
  final List<Customer> customers;

  CustomerDataSource(this.context, this.customers);

  @override
  DataRow getRow(int index) {
    if (index >= customers.length) return null as DataRow;

    final customer = customers[index];
    final no = index + 1;
    return DataRow(cells: [
      DataCell(Text(no.toString())),
      DataCell(Text(customer.name)),
      DataCell(Text(customer.phone)),
      DataCell(Text(customer.email)),
      DataCell(Text(customer.address)),
      // DataCell(Text(customer.category)),
      DataCell(
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "edit") {
              _showEditDialog(context, customer);
            } else if (value == "delete") {
              showDialog(
                context: context,
                builder: (context) => DeleteUserDialog(fileInfo: customer),
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
  int get rowCount => customers.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  void _showEditDialog(BuildContext context, Customer customer) {
    TextEditingController nameController =
        TextEditingController(text: customer.name);
    TextEditingController phoneController =
        TextEditingController(text: customer.phone);
    TextEditingController emailController =
        TextEditingController(text: customer.email);
    TextEditingController addressController =
        TextEditingController(text: customer.address);
    final HomeControllerWidget homeController = Get.put(HomeControllerWidget());
    final CustomerController customerController = Get.put(CustomerController());
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
          title: const Text("Edit Customer"),
          content: SizedBox(
            width: dialogWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField("Name", nameController),
                  _buildTextField("Phone", phoneController),
                  _buildTextField("Email", emailController),
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
                customerController.updateCustomer(customer.id!, {
                  "icon": "",
                  "name": nameController.text,
                  "phone": phoneController.text,
                  "email": emailController.text,
                  "address": addressController.text,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${nameController.text} updated!")),
                );
                homeController.onTab(5);
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
