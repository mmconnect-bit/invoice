import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._privateConstructor();
  DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "invoices.db");

    // Initialize FFI database for Windows
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    bool exists = await File(path).exists();
    if (!exists) {
      try {
        print("Copying database from assets...");
        ByteData data = await rootBundle.load("assets/database/invoices.db");
        List<int> bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes, flush: true);
        print("Database copied successfully!");
      } catch (e) {
        print("Error copying database: $e");
      }
    } else {
      print("Database already exists at: $path");
    }

    // Open the database
    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(version: 1));
  }
}
