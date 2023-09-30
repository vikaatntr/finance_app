import 'package:my_finance/helper/database.dart';
import 'package:my_finance/model/balance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<void> addBalance(Balance balance) async {
  final Database db = await initializeDatabase();
  await db.insert(
    'balance',
    balance.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<bool> getBalanceByIdUser(int idUser) async {
  final Database db = await initializeDatabase();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> results = await db.query(
    'balance',
    where: 'idUser = ?',
    whereArgs: [idUser],
  );

  if (results.isNotEmpty) {
    var id = results[0]['id'];
    await prefs.setInt('idBalance', id);
  }

//ada = isNotEmpty (true)
  return results.isNotEmpty;
}
