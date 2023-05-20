import 'package:registro_ponto/registro.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  static const _dbName = 'registro_ponto.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();

  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = '$databasePath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Registro.NOME_TABLE} (
        ${Registro.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Registro.CAMPO_DATE_TIME} TEXT,
        ${Registro.CAMPO_LATITUDE} DOUBLE,
        ${Registro.CAMPO_LONGITUDE} DOUBLE
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}