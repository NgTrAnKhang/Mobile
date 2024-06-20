import 'package:e_commerce_flutter/src/model/cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'db_cart.db');
    print(
        "Đường dẫn database: $databasePath"); // in đường dẫn chứa file database
    return await openDatabase(path, onCreate: _onCreate, version: 1
        // ,
        // onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
        );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Cart('
      'id INTEGER, title TEXT, price FLOAT, img TEXT, des TEXT, count INTEGER,user INTEGER)',
    );
  }

  Future<bool> hasData(int id, int user) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query(
      'Cart',
      where: 'id = ? and user = ?',
      whereArgs: [id, user],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> insertProduct(Cart productModel) async {
    final db = await _databaseService.database;
    print(productModel.toMap());
    await db.insert(
      'Cart',
      productModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cart>> products(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Cart');
    return List.generate(maps.length, (index) => Cart.fromMap(maps[index]));
  }

  Future<Cart> product(int id, int user) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Cart',
      where: 'id = ? AND user = ?',
      whereArgs: [id, user],
    );
    if (maps.isNotEmpty) {
      return Cart.fromMap(maps.first);
    }
    throw Exception('Product not found in the database.');
  }

  Future<void> minus(Cart product, int user) async {
    final db = await _databaseService.database;
    if (product.count > 1) {
      product.count--;
      await db.update(
        'Cart',
        product.toMap(),
        where: 'id = ? and user = ?',
        whereArgs: [product.id, user],
      );
    } else {
      deleteProduct(product.id, user);
    }
  }

  Future<void> add(Cart product, int user) async {
    final db = await _databaseService.database;
    product.count++;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'id = ? and user = ?',
      whereArgs: [product.id, user],
    );
  }

  Future<void> insert2(Cart product, int user) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT count FROM Cart WHERE title=? AND user=?',
      [product.title, user],
    );
    maps.forEach((maps) {
      print(maps);
    });
    if (maps.isNotEmpty) {
      Map<String, dynamic> firstMap = maps.first;
      int columnCount = firstMap['count'] + product.count;
      print('count: $columnCount');
      await db.rawUpdate(
        'UPDATE Cart SET count = ? WHERE id = ? AND user = ?',
        [columnCount, product.id, user],
      );
    } else {
      await db.insert(
        'Cart',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteProduct(int id, int user) async {
    final db = await _databaseService.database;
    await db.delete(
      'Cart',
      where: 'id = ? and user = ?',
      whereArgs: [id, user],
    );
  }

  Future<void> clear() async {
    final db = await _databaseService.database;
    await db.delete('Cart', where: 'count > 0');
  }

  Future<double> getTotal() async {
    final db = await _databaseService.database;
    final result =
        await db.rawQuery('SELECT SUM(price * count) AS totalSum FROM cart');

    if (result.isNotEmpty && result.first['totalSum'] != null) {
      final totalSum = result.first['totalSum'] as double;
      return totalSum;
    } else {
      return 0;
    }
  }

  Future<void> deleteAll(int user) async {
    // Get a reference to the database
    final db = await _databaseService.database;
    await db.delete(
      'Cart',
      where: 'user = ?',
      whereArgs: [user],
    );
  }
}
