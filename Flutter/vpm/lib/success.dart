// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'main.dart';

class SuccessWidget extends StatefulWidget {
  @override
  _SuccessWidgetState createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        checkerboardOffscreenLayers: false,
        title: "Trial",
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.lightGreen,
        ),
        home: Scaffold(
            appBar: AppBar(
              elevation: 10,
              centerTitle: true,
              title: const Text(
                "Welcome to Pollution Meter",
                style: TextStyle(fontSize: 28),
              ),
            ),
            body: SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(19),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.add_task_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "SUBMITTED",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 12.5,
                                    right: 12.5),
                                child: Text(
                                  "Go back Home",
                                  style: TextStyle(
                                      fontSize: 24, fontFamily: "Fredoka"),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
