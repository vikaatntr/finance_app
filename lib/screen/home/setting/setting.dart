// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:my_finance/helper/auth.dart';
import 'package:my_finance/helper/dialog.dart';
import 'package:my_finance/helper/user.dart';
import 'package:my_finance/model/user.dart';
import 'package:my_finance/screen/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  int id = 0;
  String name = "";
  String email = "";
  String nim = "";
  String password = "";

  @override
  void initState() {
    fetch();
    super.initState();
  }

  fetch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? idd = prefs.getInt('id');
    final String? namee = prefs.getString('name');
    final String? emaill = prefs.getString('email');
    final String? passwordd = prefs.getString('password');
    final String? nimm = prefs.getString('nim');

    setState(() {
      id = idd!;
      name = namee!;
      email = emaill!;
      password = passwordd!;
      nim = nimm!;
    });
  }

  void showError(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(errorMessage: errorMessage);
      },
    );
  }

  void showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
            message: 'Selamat, Anda berhasil mengganti password');
      },
    );
  }

  validatePassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var validate = await authenticateUserNotCreateBalance(
        email, _oldPasswordController.text);
    if (!validate) {
      // ignore: use_build_context_synchronously
      return showError(context, "password lama salah");
    }

    var user = User(
        id: id,
        nama: name,
        email: email,
        password: _newPasswordController.text,
        nim: nim);

    await updateUser(user);

    await prefs.setString('password', _newPasswordController.text);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();

    return showSuccess(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.purple[800],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(
              Icons.logout,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 110.0,
              ),
              width: MediaQuery.of(context).size.width,
              color: Colors.purple[800],
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        "https://image.cnbcfm.com/api/v1/image/107241090-1684160036619-gettyimages-1255019394-AFP_33F44YL.jpeg?v=1685596344"),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hello",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _oldPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Old Password',
                        ),
                      ),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green, // Background color
                        ),
                        onPressed: () {
                          validatePassword();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
