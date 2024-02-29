// ignore_for_file: unused_import, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'mongo.dart';
import 'main.dart';

class AdminHome extends StatefulWidget {
  @override
  AdminHomeState createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: AdminHomeWidget()),
    );
  }
}

class AdminHomeWidget extends StatefulWidget {
  @override
  State<AdminHomeWidget> createState() => _AdminHomeWidgetState();
}

class _AdminHomeWidgetState extends State<AdminHomeWidget> {
  late Future<List<dynamic>> vehicleData;
  List<dynamic> data = [];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Hello, admin",
                            style:
                                TextStyle(fontSize: 24, fontFamily: "Fredoka"),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                );
                              },
                              icon: const Icon(Icons.logout))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                vehicleData = vehicleDetails();
                              });
                              final fetchedData = await vehicleData;
                              setState(() {
                                data =
                                    fetchedData; // Assign the fetched data to the data variable
                              });
                              print(data);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40),
                              child: Text(
                                "Refresh the data",
                                style: TextStyle(
                                    fontSize: 23, fontFamily: "Fredoka"),
                              ),
                            )),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Vehicle Number")),
                            DataColumn(label: Text("Engine Stage")),
                            DataColumn(label: Text("Engine Capacity")),
                            DataColumn(label: Text("Fuel")),
                            DataColumn(label: Text("Carbon Dioxide Value")),
                            DataColumn(label: Text("Carbon Monoxide Value")),
                          ],
                          rows: data
                              .map((vehicle) => DataRow(cells: [
                                    DataCell(Text(
                                        vehicle['Vehicle Number'].toString())),
                                    DataCell(Text(
                                        vehicle['Engine Stage'].toString())),
                                    DataCell(Text(
                                        vehicle['Engine Capacity'].toString())),
                                    DataCell(Text(vehicle['Fuel'].toString())),
                                    DataCell(Text(
                                        vehicle['Carbon Dioxide Value']
                                            .toString())),
                                    DataCell(Text(
                                        vehicle['Carbon Monoxide Value']
                                            .toString())),
                                  ]))
                              .toList(),
                        ),
                      ),
                    ],
                  )),
            ),
          )),
    );
  }
}
