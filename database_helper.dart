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
    _database = await _initDB('hairsalon_v6.db'); // Nâng cấp lên v6 để đồng bộ cột
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // 1. Bảng tài khoản khách hàng
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        fullName TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // 2. Bảng dịch vụ (Kiểu tóc)
    await db.execute('''
      CREATE TABLE services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price TEXT,
        category TEXT,
        description TEXT
      )
    ''');

    // 3. Bảng đặt lịch (Đã thêm đầy đủ cột để khớp với Model Customer)
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        service TEXT,
        barber TEXT,
        date TEXT,
        time TEXT,
        created_at TEXT
      )
    ''');

    // Nạp dữ liệu mẫu ban đầu
    await db.insert('users', {'username': 'admin', 'password': '123', 'fullName': 'Quản trị viên', 'role': 'admin'});
    
    for (var style in ServiceData.hairStyles) {
      await db.insert('services', {'name': style.name, 'price': style.price, 'category': 'Cắt tóc'});
    }
  }

  // Lấy danh sách dịch vụ từ DB
  Future<List<HairService>> getServicesByCategory(String category) async {
    if (kIsWeb) return ServiceData.hairStyles;
    final db = await instance.database;
    final result = await db.query('services', where: 'category = ?', whereArgs: [category]);
    return result.map((json) => HairService(name: json['name'] as String, price: json['price'] as String)).toList();
  }

  // Lưu thông tin khách hàng đặt lịch
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
    final id = await db.insert('customers', customer.toMap());
    print("--- ĐÃ LƯU ĐẶT LỊCH THÀNH CÔNG: ID $id ---");
    return id;
  }

  // Lấy toàn bộ lịch sử đặt lịch
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

  // Đăng ký người dùng mới
  Future<int> registerUser(UserModel user) async {
    if (kIsWeb) {
      final users = await _getWebUsers();
      if (users.any((u) => u.username == user.username)) return -1;
      users.add(user); await _saveWebUsers(users); return 1;
    }
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  // Đăng nhập
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
