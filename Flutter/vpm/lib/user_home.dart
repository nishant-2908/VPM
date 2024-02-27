// ignore_for_file: use_build_context_synchronously, unused_field, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'mongo.dart';
import 'package:flutter/services.dart';
import 'success.dart';

class VAHome extends StatefulWidget {
  final String userValue;
  final String deviceAddress;

  VAHome({required this.userValue, required this.deviceAddress});

  @override
  VAHomeState createState() => VAHomeState();
}

class VAHomeState extends State<VAHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VAHomeWidget(
        userValue: widget.userValue,
        deviceAddress: widget.deviceAddress,
      ),
    );
  }
}

class VAHomeWidget extends StatefulWidget {
  final String userValue;
  final String deviceAddress;

  VAHomeWidget({required this.userValue, required this.deviceAddress});

  @override
  State<StatefulWidget> createState() => _VAHomeWidgetState();
}

class _VAHomeWidgetState extends State<VAHomeWidget> {
  bool isTrue = false;
  final DAcontroller = TextEditingController();
  final VNcontroller = TextEditingController();
  bool _isVisible = false;
  bool isFinal = true;
  bool isWrong = false;
  @override
  void initState() {
    super.initState();
    VNcontroller.addListener(updateButtonVisibility);
    _isVisible = checkVehicleNumber(VNcontroller.text);
  }

  @override
  void dispose() {
    VNcontroller.dispose();
    super.dispose();
  }

  void updateButtonVisibility() {
    final isValidVehicleNumber = checkVehicleNumber(VNcontroller.text);
    setState(() {
      _isVisible = isValidVehicleNumber;
    });
  }

  bool checkVehicleNumber(String vehicleNumber) {
    final pattern =
        RegExp(r'^[A-Z]{2}\d{2}[A-Z]{2}\d{4}$', caseSensitive: false);

    if (pattern.hasMatch(vehicleNumber)) {
      return true;
    }
    return false;
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
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: Column(children: <Widget>[
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          "Enter Vehicle Number (Capital Letters only)",
                                          style: TextStyle(fontSize: 21),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: TextField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                      UpperCaseTextFormatter(),
                                    ],
                                    obscureText: false,
                                    style: const TextStyle(fontSize: 19),
                                    controller: VNcontroller,
                                    decoration: InputDecoration(
                                      hintText: 'Vehicle Number',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          255, 235, 236, 234),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 40),
                                  child: Visibility(
                                    visible:
                                        (checkVehicleNumber(VNcontroller.text)),
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            Map data = await getVehicleDetails(
                                                VNcontroller.text);
                                            if (data['document'] == null) {
                                              setState(() {
                                                isWrong = true;
                                              });
                                            } else {
                                              var isSuccess =
                                                  await updateTheValue(
                                                      widget.deviceAddress,
                                                      VNcontroller.text,
                                                      data['document'][
                                                              'Engine Capacity']
                                                          .toString(),
                                                      data['document']
                                                              ['Engine Stage']
                                                          .toString(),
                                                      data['document']
                                                              ['Fuel Type']
                                                          .toString());
                                              if (isSuccess) {
                                                setState(() {
                                                  isFinal = false;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SuccessWidget()));
                                              } else {
                                                setState(() {
                                                  isFinal = true;
                                                });
                                              }
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 25,
                                                right: 25),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily: "Fredoka"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                            visible: isWrong,
                                            child: const Text(
                                              "No vehicle number found or has already been taken",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 19),
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
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
