// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_finance/helper/auth.dart';
import 'package:my_finance/helper/dialog.dart';
import 'package:my_finance/screen/home/home.dart';
import 'package:my_finance/screen/register/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void showError(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(errorMessage: errorMessage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.blueGrey,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 48),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF1E6FF),
          iconColor: Colors.blueGrey,
          prefixIconColor: Colors.blueGrey,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Blur(
              blur: 10.0,
              blurColor: Colors.blueGrey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://image.winudf.com/v2/image1/Y29tLnBvcnRyYWl0LndhbGxwYXBlci5wb3J0cmFpdHdhbGxwYXBlcl9zY3JlZW5fMF8xNTQ3ODg0ODg0XzA3Nw/screen-0.webp?fakeurl=1&type=.webp",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Theme(
                      data: ThemeData(
                        textTheme: GoogleFonts.pacificoTextTheme().copyWith(
                          displayLarge: TextStyle(
                            color: Colors.grey[800],
                          ),
                          displayMedium: TextStyle(
                            color: Colors.grey[800],
                          ),
                          bodyLarge: TextStyle(
                            color: Colors.grey[800],
                          ),
                          bodyMedium: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      child: Text(
                        "My Finance",
                        style: GoogleFonts.pacifico(
                          color: Colors.white,
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.blueGrey,
                            controller: _emailController,
                            onChanged: (value) {
                              //
                            },
                            decoration: const InputDecoration(
                              hintText: "Your email",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.person),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              cursorColor: Colors.blueGrey,
                              controller: _passwordController,
                              onChanged: (value) async {
                                //
                              },
                              decoration: const InputDecoration(
                                hintText: "Your password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.lock),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Hero(
                            tag: "login_btn",
                            child: ElevatedButton(
                              onPressed: () async {
                                var email = _emailController.text;
                                var password = _passwordController.text;

                                final isAuthenticated =
                                    await authenticateUser(email, password);
                                if (isAuthenticated) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showError(context, "gagal login");
                                }
                              },
                              child: Text(
                                "Login".toUpperCase(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    InkWell(
                        child: Text("register"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
