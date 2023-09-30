import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeDatabase() async {
  final path = join(await getDatabasesPath(), 'my_database.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT,
          email TEXT,
          password TEXT,
          nim TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE balance(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idUser INTEGER,
          nominal REAL,
          FOREIGN KEY (idUser) REFERENCES users(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE balance_detail(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idBalance INTEGER,
          type TEXT,
          nominal REAL,
          desc TEXT,
          date TEXT,
          FOREIGN KEY (idBalance) REFERENCES balance(id)
        )
      ''');
    },
  );
}
