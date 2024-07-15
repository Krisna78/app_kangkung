import 'package:app_kangkung/model/income.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('income.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const String sql = '''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      periode_tanggal TEXT NOT NULL,
      type TEXT CHECK(type IN ('income', 'expense')) NOT NULL,
      quantity INTEGER NOT NULL,
      harga_satuan INTEGER NOT NULL,
      amount INTEGER NOT NULL,
      title TEXT NOT NULL,
      deskripsi TEXT
    );
    ''';
    await db.execute(sql);
  }

  Future<void> insertIncome(Income income) async {
    final db = await instance.database;
    await db.insert(
      'transactions',
      income.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Income>> fetchIncomes() async {
    final db = await instance.database;
    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);
    final result = await db.query(
      'transactions',
      where: 'periode_tanggal = ?',
      whereArgs: [todayString],
    );
    return result.map((json) => Income.fromMap(json)).toList();
  }

  Future<Income?> fetchIncomeById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Income.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateIncome(Income income) async {
    final db = await database;
    await db.update(
      'transactions',
      income.toMap(),
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  Future<int> deleteIncome(int id) async {
    final db = await instance.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
