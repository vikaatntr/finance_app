import 'package:my_finance/helper/database.dart';
import 'package:my_finance/model/user.dart';
import 'package:sqflite/sqflite.dart';

Future<int> addUser(User user) async {
  final Database db = await initializeDatabase();
  var result = await db.insert(
    'users',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  return result;
}

Future<void> updateUser(User user) async {
  final Database db = await initializeDatabase();
  await db.update(
    'users',
    user.toMap(),
    where: "id = ?",
    whereArgs: [user.id],
  );
}
