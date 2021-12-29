import 'package:app/src/model/currency.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  late Database _database;

  Future init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'currencyDB.db');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(''' 
            CREATE TABLE currency
            (
              key TEXT PRIMARY KEY,
              name TEXT,
              value REAL,
              timestamp INTEGER
            )
          ''');
      await db.execute(''' 
            CREATE TABLE enabledCurrency
            (
              key TEXT PRIMARY KEY,
              position INTEGER
            )
          ''');
      await db.rawInsert(
          'INSERT INTO enabledCurrency (key, position) VALUES ("EUR", 1)');
      await db.rawInsert(
          'INSERT INTO enabledCurrency (key, position) VALUES ("USD", 2)');
      await db.rawInsert(
          'INSERT INTO enabledCurrency (key, position) VALUES ("JPY", 3)');

      await db.execute(''' 
            CREATE TABLE selectedCurrency
            (
              id INTEGER PRIMARY KEY,
              key TEXT
            )
          ''');
      await db.rawInsert(
          'INSERT INTO selectedCurrency (id, key) VALUES (1, "EUR")');
    });

    return this;
  }

  Future<int> insert(Currency currency) async {
    return _database.insert('currency', currency.toMapDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Currency>> getCurrencies() async {
    final query = '''
      SELECT
        currency.key, 
        currency.name, 
        currency.value, 
        currency.timestamp,
        CASE
          WHEN enabledCurrency.position IS NULL THEN 
            -1
          ELSE
            enabledCurrency.position 
          END position
        CASE
          WHEN enabledCurrency.key IS NULL THEN
            0
          ELSE
            1
          END isEnabled
      FROM 
        currency
      LEFT JOIN
        enabledCurrency
      ON
        currency.key = enabledCurrency.key
      ORDER BY
        isEnabled DESC,
        currency.key ASC
    ''';
    final result = await _database.rawQuery(query);
    return result.map((e) => Currency.fromMapDB(e)).toList();
  }
}
