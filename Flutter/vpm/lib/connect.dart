// ignore_for_file: use_build_context_synchronously, unused_field, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'main.dart';
import 'mongo.dart';
import 'package:flutter/services.dart';
import 'user_home.dart';

class UserHome extends StatefulWidget {
  final String userValue;
  UserHome({required this.userValue});

  @override
  UserHomeState createState() => UserHomeState();
}

class UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserHomeWidget(userValue: widget.userValue),
    );
  }
}

class UserHomeWidget extends StatefulWidget {
  final String userValue;

  UserHomeWidget({required this.userValue});

  @override
  State<UserHomeWidget> createState() => _UserHomeWidgetState();
}

class _UserHomeWidgetState extends State<UserHomeWidget> {
  final DAcontroller = TextEditingController();
  bool _isVisible = false;
  bool warning = false;
  @override
  void initState() {
    super.initState();
    DAcontroller.addListener(updateButtonVisibility);
    _isVisible = checkDA(DAcontroller.text);
  }

  @override
  void dispose() {
    DAcontroller.dispose();
    super.dispose();
  }

  void updateButtonVisibility() {
    final isValidDA = checkDA(DAcontroller.text);
    setState(() {
      _isVisible = isValidDA;
    });
  }

  bool checkDA(String DA) {
    return DA.trim().length == 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        centerTitle: true,
        title: const Text(
          "Welcome to Pollution Meter",
          style: TextStyle(fontSize: 24, fontFamily: "Poppins"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hey, ${widget.userValue.toUpperCase()}",
                        style: const TextStyle(
                            fontSize: 21, fontFamily: "Fredoka"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 1),
                                ),
                                Text(
                                  "Enter Device Address (3 characters)",
                                  style: TextStyle(fontSize: 21),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextField(
                              style: const TextStyle(fontSize: 19),
                              controller: DAcontroller,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                UpperCaseTextFormatter(),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Device Address',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 235, 236, 234),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                          visible: _isVisible,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool response =
                                  await updateTheSwitch(DAcontroller.text);
                              if (response) {
                                setState(() {
                                  warning = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VAHome(
                                            userValue: widget.userValue,
                                            deviceAddress: DAcontroller.text,
                                          )),
                                );
                              } else {
                                setState(() {
                                  warning = true;
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 80),
                              child: Text(
                                "Connect ",
                                style: TextStyle(fontSize: 26),
                              ),
                            ),
                          )),
                      Visibility(
                          visible: warning,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Invalid Device Address",
                              style: TextStyle(color: Colors.red, fontSize: 19),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.toUpperCase();
    return newValue.copyWith(text: newText);
  }
}
