import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance = LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'seimbangin_local.db');
    return await openDatabase(
      path,
      version: 2, // Upgraded version to include categories
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount REAL,
        type TEXT,
        category TEXT,
        date TEXT,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        icon_code INTEGER
      )
    ''');
    await _insertDefaultCategories(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          type TEXT,
          icon_code INTEGER
        )
      ''');
      await _insertDefaultCategories(db);
    }
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final List<Map<String, dynamic>> defaults = [
      {'name': 'Gaji', 'type': 'income', 'icon_code': 0xe0b2}, // point_of_sale
      {'name': 'Freelance', 'type': 'income', 'icon_code': 0xe6e0}, // work
      {'name': 'Hadiah', 'type': 'income', 'icon_code': 0xee56}, // card_giftcard
      {'name': 'Makan', 'type': 'outcome', 'icon_code': 0xe532}, // restaurant
      {'name': 'Belanja', 'type': 'outcome', 'icon_code': 0xe59c}, // shopping_cart
      {'name': 'Transportasi', 'type': 'outcome', 'icon_code': 0xe199}, // commute
      {'name': 'Internet', 'type': 'outcome', 'icon_code': 0xec78}, // wifi
      {'name': 'Lainnya', 'type': 'outcome', 'icon_code': 0xe43f}, // category
      {'name': 'Lainnya', 'type': 'income', 'icon_code': 0xe43f}, // category
    ];

    for (var cat in defaults) {
      await db.insert('categories', cat);
    }
  }

  // --- Transactions Operations --- //

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('transactions', row);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    Database db = await database;
    return await db.query('transactions', orderBy: 'date DESC');
  }

  Future<int> deleteTransaction(int id) async {
    Database db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // --- Analytics Queries --- //

  Future<List<Map<String, dynamic>>> getTransactionsByMonth(
      int year, int month) async {
    Database db = await database;
    final monthStr = month.toString().padLeft(2, '0');
    return await db.rawQuery('''
      SELECT * FROM transactions
      WHERE strftime('%Y', date) = ? AND strftime('%m', date) = ?
      ORDER BY date ASC
    ''', [year.toString(), monthStr]);
  }

  Future<double> getMonthlyIncome(int year, int month) async {
    Database db = await database;
    final monthStr = month.toString().padLeft(2, '0');
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total FROM transactions
      WHERE strftime('%Y', date) = ? AND strftime('%m', date) = ? AND type = 'income'
    ''', [year.toString(), monthStr]);
    return (result.first['total'] as num).toDouble();
  }

  Future<double> getMonthlyExpense(int year, int month) async {
    Database db = await database;
    final monthStr = month.toString().padLeft(2, '0');
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total FROM transactions
      WHERE strftime('%Y', date) = ? AND strftime('%m', date) = ? AND type = 'outcome'
    ''', [year.toString(), monthStr]);
    return (result.first['total'] as num).toDouble();
  }

  Future<Map<int, Map<String, double>>> getDailyCashflow(
      int year, int month) async {
    Database db = await database;
    final monthStr = month.toString().padLeft(2, '0');
    final rows = await db.rawQuery('''
      SELECT CAST(strftime('%d', date) AS INTEGER) as day,
             SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as income,
             SUM(CASE WHEN type = 'outcome' THEN amount ELSE 0 END) as outcome
      FROM transactions
      WHERE strftime('%Y', date) = ? AND strftime('%m', date) = ?
      GROUP BY strftime('%d', date)
      ORDER BY day ASC
    ''', [year.toString(), monthStr]);

    final Map<int, Map<String, double>> result = {};
    for (final row in rows) {
      final day = row['day'] as int;
      result[day] = {
        'income': (row['income'] as num).toDouble(),
        'outcome': (row['outcome'] as num).toDouble(),
      };
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getCategorySummary(
      int year, int month, String? type) async {
    Database db = await database;
    final monthStr = month.toString().padLeft(2, '0');

    String whereClause =
        "WHERE strftime('%Y', date) = ? AND strftime('%m', date) = ?";
    List<String> params = [year.toString(), monthStr];

    if (type != null && type != 'all') {
      whereClause += ' AND type = ?';
      params.add(type);
    }

    return await db.rawQuery('''
      SELECT category, SUM(amount) as total, type
      FROM transactions
      $whereClause
      GROUP BY category
      ORDER BY total DESC
    ''', params);
  }

  Future<Map<String, double>> getOverallTotals() async {
    Database db = await database;
    final result = await db.rawQuery('''
      SELECT
        COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) as totalIncome,
        COALESCE(SUM(CASE WHEN type = 'outcome' THEN amount ELSE 0 END), 0) as totalOutcome
      FROM transactions
    ''');
    final row = result.first;
    final totalIncome = (row['totalIncome'] as num).toDouble();
    final totalOutcome = (row['totalOutcome'] as num).toDouble();
    return {
      'totalIncome': totalIncome,
      'totalOutcome': totalOutcome,
      'netBalance': totalIncome - totalOutcome,
    };
  }

  Future<Map<int, Map<String, double>>> getYearlyCashflow(int year) async {
    Database db = await database;
    final rows = await db.rawQuery('''
      SELECT CAST(strftime('%m', date) AS INTEGER) as month,
             SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as income,
             SUM(CASE WHEN type = 'outcome' THEN amount ELSE 0 END) as outcome
      FROM transactions
      WHERE strftime('%Y', date) = ?
      GROUP BY strftime('%m', date)
      ORDER BY month ASC
    ''', [year.toString()]);

    final Map<int, Map<String, double>> result = {};
    for (final row in rows) {
      final month = row['month'] as int;
      result[month] = {
        'income': (row['income'] as num).toDouble(),
        'outcome': (row['outcome'] as num).toDouble(),
      };
    }
    return result;
  }

  // --- Categories Operations --- //

  Future<int> insertCategory(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('categories', row);
  }

  Future<List<Map<String, dynamic>>> getCategories(String type) async {
    Database db = await database;
    return await db.query('categories', where: 'type = ?', whereArgs: [type], orderBy: 'id ASC');
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    Database db = await database;
    return await db.query('categories', orderBy: 'id ASC');
  }

  Future<int> deleteCategory(int id) async {
    Database db = await database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
