import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer.dart';
import '../models/user_model.dart';
import '../models/service.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const String _usersKey = 'web_users';
  static const String _customersKey = 'web_customers';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (kIsWeb) throw Exception("SQLite không hỗ trợ Web");
    if (_database != null) return _database!;
    _database = await _initDB('hairsalon_v10.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(50) NOT NULL,
        fullName VARCHAR(100) NOT NULL,
        role VARCHAR(20) NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(100) NOT NULL,
        price VARCHAR(20),
        category VARCHAR(50),
        description VARCHAR(255)
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(100) NOT NULL,
        phone VARCHAR(20),
        email VARCHAR(50),
        service VARCHAR(100),
        barber VARCHAR(100),
        date DATE,
        time TIME,
        created_at DATETIME
      )
    ''');

    await db.insert('users', {'username': 'admin', 'password': '123', 'fullName': 'Quản trị viên', 'role': 'admin'});
    
    for (var style in ServiceData.hairStyles) {
      await db.insert('services', {'name': style.name, 'price': style.price, 'category': 'Cắt tóc'});
    }
  }

  Future<List<HairService>> getServicesByCategory(String category) async {
    if (kIsWeb) return ServiceData.hairStyles;
    final db = await instance.database;
    final result = await db.query('services', where: 'category = ?', whereArgs: [category]);
    return result.map((json) => HairService(
      name: json['name'].toString(), 
      price: json['price'].toString()
    )).toList();
  }

  Future<int> insertCustomer(Customer customer) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_customersKey);
      List decoded = data != null ? json.decode(data) : [];
      decoded.add(customer.toMap());
      await prefs.setString(_customersKey, json.encode(decoded));
      return 1;
    }
    final db = await instance.database;
    return await db.insert('customers', customer.toMap());
  }

  Future<List<Customer>> getAllCustomers() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_customersKey);
      if (data == null) return [];
      final List decoded = json.decode(data);
      return decoded.map((c) => Customer.fromMap(c)).toList();
    }
    final db = await instance.database;
    final result = await db.query('customers', orderBy: 'id DESC');
    return result.map((json) => Customer.fromMap(json)).toList();
  }

  Future<int> registerUser(UserModel user) async {
    if (kIsWeb) {
      final users = await _getWebUsers();
      if (users.any((u) => u.username == user.username)) return -1;
      users.add(user); await _saveWebUsers(users); return 1;
    }
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> loginUser(String username, String password) async {
    if (kIsWeb) {
      final users = await _getWebUsers();
      try { return users.firstWhere((u) => u.username == username && u.password == password); } catch (e) { return null; }
    }
    final db = await instance.database;
    final result = await db.query('users', where: 'username = ? AND password = ?', whereArgs: [username, password]);
    if (result.isNotEmpty) return UserModel.fromMap(result.first);
    return null;
  }

  Future<List<UserModel>> _getWebUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_usersKey);
    if (data == null) return [UserModel(username: 'admin', password: '123', fullName: 'Quản trị viên', role: 'admin')];
    return (json.decode(data) as List).map((u) => UserModel.fromMap(u)).toList();
  }

  Future<void> _saveWebUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, json.encode(users.map((u) => u.toMap()).toList()));
  }
}
