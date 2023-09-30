// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:my_finance/helper/auth.dart';
import 'package:my_finance/helper/balance.dart';
import 'package:my_finance/helper/dialog.dart';
import 'package:my_finance/helper/user.dart';
import 'package:my_finance/model/balance.dart';
import 'package:my_finance/model/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nimController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          return SuccessDialog(message: 'Selamat, Anda berhasil mendaftar.');
        },
      );
    }

    clearAll() {
      setState(() {
        _emailController = TextEditingController();
        _nameController = TextEditingController();
        _nimController = TextEditingController();
        _passwordController = TextEditingController();
      });
    }

    createUser() async {
      try {
        final nama = _nameController.text;
        final email = _emailController.text;
        final password = _passwordController.text;
        final nim = _nimController.text;
        if (nama.isEmpty || email.isEmpty || password.isEmpty || nim.isEmpty) {
          return showError(context, "harap isi semuanya");
        }

        final cek = await checkEmail(email);
        if (cek) {
          // ignore: use_build_context_synchronously
          return showError(context, "email sudah terdaftar");
        }

        final user =
            User(nama: nama, email: email, password: password, nim: nim);
        final resultUser = await addUser(user);

        var balance = Balance(idUser: resultUser, nominal: 0);
        await addBalance(balance);
        clearAll();
        // ignore: use_build_context_synchronously
        return showSuccess(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        showError(context, e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _nimController,
                decoration: InputDecoration(
                  labelText: 'NIM',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white, // Background color
              ),
              onPressed: () {
                createUser();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
