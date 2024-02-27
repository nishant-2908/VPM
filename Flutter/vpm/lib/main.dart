// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'admin.dart';
import 'user.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const Text(
                    "Select Designation",
                    style: TextStyle(fontSize: 25, fontFamily: "Fredoka"),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        const Text(
                          "If you are a Police Officer, then select the below option",
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UserWidget()),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 80),
                                      child: Text(
                                        "Officer",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontFamily: "Fredoka"),
                                      ),
                                    ))
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.only(top: 18.0),
                          child: Text(
                            "If you are an Admin, then select the below option",
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminWidget()),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 80),
                                    child: Text(
                                      "Admin",
                                      style: TextStyle(
                                          fontSize: 26, fontFamily: "Fredoka"),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 240, 240, 240)),
                          alignment: Alignment.topLeft,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                  "Breathe Easier, \n Drive Greener with Us",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 69, 166, 73),
                                      fontSize: 28,
                                      fontFamily: "Fredoka")),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
