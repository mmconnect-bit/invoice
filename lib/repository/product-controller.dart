import 'package:admin/models/product_list.dart';
import 'package:admin/repository/database-helper.dart';
import 'package:get/get.dart';

import 'package:sqflite/sqflite.dart';

class ProductController extends GetxController {
  DBHelper dbHelper = DBHelper.instance;

  @override
  void onInit() {
    super.onInit();

    fetchProducts();
  }

  Future<int> createProduct(Map<String, dynamic> product) async {
    Database db = await dbHelper.database;
    return await db.insert("Products", product);
  }

  Future<List<Product>> fetchProducts() async {
    Database db = await dbHelper.database;

    List<Product> products = [];
    final List<Map<String, dynamic>> response = await db.query(
      "Products",
      orderBy: "id DESC",
    );
    products.assignAll(Product.fromMapList(response));
    return products;
  }

  Future<int> updateProduct(int id, Map<String, dynamic> product) async {
    Database db = await dbHelper.database;
    return await db
        .update("Products", product, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteProduct(int id) async {
    Database db = await dbHelper.database;
    return await db.delete("Products", where: "id = ?", whereArgs: [id]);
  }
}
