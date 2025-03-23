import 'package:admin/models/customer.dart';
import 'package:admin/repository/database-helper.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class CustomerController extends GetxController {
  DBHelper dbHelper = DBHelper.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<int> createCustomer(Map<String, dynamic> customer) async {
    Database db = await dbHelper.database;
    return await db.insert("Customers", customer);
  }

 Future<List<Customer>> fetchCustomers() async {
  Database db = await dbHelper.database;

  final List<Map<String, dynamic>> response = await db.query(
    "Customers",
    orderBy: "id DESC", 
  );

  List<Customer> customers = [];
  customers.assignAll(Customer.fromMapList(response));
  return customers;
}

  Future<int> updateCustomer(int id, Map<String, dynamic> customer) async {
    Database db = await dbHelper.database;
    return await db
        .update("Customers", customer, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteCustomer(int id) async {
    Database db = await dbHelper.database;
    return await db.delete("Customers", where: "id = ?", whereArgs: [id]);
  }
}
