import 'package:flutter/material.dart';
import 'package:my_finance/helper/database.dart';
import 'package:my_finance/screen/home/home.dart';
import 'package:my_finance/screen/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int? userId = prefs.getInt("id");
  await initializeDatabase();
  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      useMaterial3: true,
    ),
    home: userId != null ? const HomeScreen() : const LoginScreen(),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
//         useMaterial3: true,
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }
