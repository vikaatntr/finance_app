import 'package:my_finance/helper/balance.dart';
import 'package:my_finance/helper/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<bool> authenticateUser(String email, String password) async {
  final Database db = await initializeDatabase();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> results = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );

  if (results.isNotEmpty) {
    var id = results[0]['id'];
    var name = results[0]['nama'];
    var email = results[0]['email'];
    var nim = results[0]['nim'];
    var password = results[0]['password'];
    await prefs.setInt('id', id);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('nim', nim);
    await prefs.setString('password', password);
  }

  await getBalanceByIdUser(results[0]['id']);

  return results.isNotEmpty;
}

Future<bool> authenticateUserNotCreateBalance(
    String email, String password) async {
  final Database db = await initializeDatabase();
  final List<Map<String, dynamic>> results = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );

  return results.isNotEmpty;
}

Future<bool> checkEmail(String email) async {
  final Database db = await initializeDatabase();
  final List<Map<String, dynamic>> results = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );

//ada = isNotEmpty (true)
  return results.isNotEmpty;
}
