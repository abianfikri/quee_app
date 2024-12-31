import 'package:quee_app/data/models/antrian.dart';
import 'package:sqflite/sqflite.dart';

class AntrianLocalDatasources {
  AntrianLocalDatasources._init();

  static final AntrianLocalDatasources instance =
      AntrianLocalDatasources._init();

  final String tableAntrian = 'tbl_antrian';

  static Database? _database;

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableAntrian (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT,
    noAntrian TEXT,
    isActive INTEGER
    )
    ''');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('antrian.db');
    return _database!;
  }

  Future saveAntrian(Antrian antrian) async {
    final db = await instance.database;
    await db.insert(tableAntrian, antrian.toMap());
  }

  Future<List<Antrian>> getAllAntrian() async {
    final db = await instance.database;
    final result = await db.query(tableAntrian);
    return result.map((e) => Antrian.fromMap(e)).toList();
  }

  Future updateAntrian(Antrian antrian) async {
    final db = await instance.database;
    await db.update(
      tableAntrian,
      antrian.toMap(),
      where: 'id = ?',
      whereArgs: [antrian.id],
    );
  }

  Future deleteAntrian(int id) async {
    final db = await instance.database;
    await db.delete(
      tableAntrian,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
