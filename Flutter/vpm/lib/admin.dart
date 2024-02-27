// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:vpm/main.dart';
import 'admin_home.dart';

class AdminWidget extends StatefulWidget {
  @override
  _AdminWidgetState createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<AdminWidget> {
  bool isTrue = false;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isVisible = false;
  String userNameWarning = '';
  bool incorrect = false;
  @override
  void initState() {
    super.initState();
    userNameController.addListener(updateButtonVisibility);
    passwordController.addListener(updateButtonVisibility);
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void updateButtonVisibility() {
    final isValid = checkUsernameAndPassword(
      userNameController.text,
      passwordController.text,
    );
    setState(() {
      _isVisible = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyWidget()),
            );
          },
        ),
        elevation: 10,
        centerTitle: true,
        title: const Text(
          "Welcome to Pollution Meter",
          style: TextStyle(fontSize: 24, fontFamily: "Poppins"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              "Hey admin!",
                              style: TextStyle(
                                  fontSize: 25, fontFamily: "Fredoka"),
                            ),
                          ),
                          Text(
                            "Enter Username",
                            style: TextStyle(fontSize: 21),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: TextField(
                        style: const TextStyle(fontSize: 19),
                        controller: userNameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 235, 236, 234),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Enter Password",
                              style: TextStyle(fontSize: 21),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      child: TextField(
                        obscureText: true,
                        style: const TextStyle(fontSize: 19),
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 235, 236, 234),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Visibility(
                        visible: _isVisible,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                isTrue = checkPassword(userNameController.text,
                                    passwordController.text);
                                if (isTrue) {
                                  setState(() {
                                    incorrect = false;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminHome()),
                                  );
                                } else {
                                  setState(() {
                                    incorrect = true;
                                  });
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 80),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      fontSize: 24, fontFamily: "Fredoka"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Visibility(
                          visible: (incorrect),
                          child: const Text(
                            "Incorrect password",
                            style: TextStyle(color: Colors.red, fontSize: 19),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkUsernameAndPassword(String a, String b) {
    if (a.trim().isEmpty || b.trim().isEmpty) {
      return false;
    }
    return true;
  }

  bool checkPassword(String a, String b) {
    if (a == 'admin' && b == 'admin') {
      return true;
    } else {
      return false;
    }
  }
}
