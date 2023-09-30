import 'package:my_finance/helper/database.dart';
import 'package:my_finance/model/balance_detail.dart';
import 'package:sqflite/sqflite.dart';

Future<void> addBalanceDetail(BalanceDetail balance) async {
  final Database db = await initializeDatabase();
  await db.insert(
    'balance_detail',
    balance.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<BalanceDetail>> getBalanceDetailByIdUser(int idBalance) async {
  final Database db = await initializeDatabase();
  final List<Map<String, dynamic>> results = await db.query(
    'balance_detail',
    where: 'idBalance = ?',
    whereArgs: [idBalance],
  );

  return List.generate(results.length, (i) {
    return BalanceDetail(
      idBalance: results[i]['idBalance'],
      type: results[i]['type'],
      nominal: results[i]['nominal'],
      desc: results[i]['desc'],
      date: results[i]['date'],
    );
  });
}

Future<double> getTotalBalanceByType(String type, int idBalance) async {
  final Database db = await initializeDatabase();
  final List<Map<String, dynamic>> results = await db.query(
    'balance_detail',
    where: 'type = ? AND idBalance = ?',
    whereArgs: [type, idBalance],
  );

  double total = 0;
  for (var i = 0; i < results.length; i++) {
    var item = results[i]['nominal'];
    total += item;
  }

  return total;
}

Future<List<BalanceDetail>> getBalanceByType(String type, int idBalance) async {
  final Database db = await initializeDatabase();
  final List<Map<String, dynamic>> results = await db.query(
    'balance_detail',
    where: 'type = ? AND idBalance = ?',
    whereArgs: [type, idBalance],
  );

  return List.generate(results.length, (i) {
    return BalanceDetail(
      idBalance: results[i]['idBalance'],
      type: results[i]['type'],
      nominal: results[i]['nominal'],
      desc: results[i]['desc'],
      date: results[i]['date'],
    );
  });
}
