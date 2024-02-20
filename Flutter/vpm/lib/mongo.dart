// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> checkUsername(String username, String password) async {
  String url =
      "https://ap-south-1.aws.data.mongodb-api.com/app/data-egfvn/endpoint/data/v1/action/findOne";
  Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, PUT, POST, DELETE',
    'Access-Control-Allow-Headers':
        'Origin, X-Requested-With, Content-Type, Accept',
    'Access-Control-Request-Headers': '*',
    'api-key':
        'r6ceRUK4eE7Iez5heqJyDalib5e3CJcCuVJxY8jnq9vqwW5gGZJQLAN6HMFkQVbs',
  };
  Map<String, dynamic> body = {
    "collection": "VP_Collection",
    "database": "VP_Users",
    "dataSource": "AtlasCluster",
    "filter": {
      "Username": username,
    }
  };
  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );
  var responseBody = jsonDecode(response.body);
  if (response.statusCode == 200) {
    if (response.statusCode == 200) {
      if (responseBody['document'] != null) {
        if (responseBody['document']['Password'] == password) {
          return "Success";
        } else {
          return "Incorrect Password";
        }
      } else {
        return "No such user";
      }
    }
  }
  return "Function completed";
}

Future<List> vehicleDetails() async {
  String url =
      "https://ap-south-1.aws.data.mongodb-api.com/app/data-egfvn/endpoint/data/v1/action/find";
  Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, PUT, POST, DELETE',
    'Access-Control-Allow-Headers':
        'Origin, X-Requested-With, Content-Type, Accept',
    'Access-Control-Request-Headers': '*',
    'api-key':
        'r6ceRUK4eE7Iez5heqJyDalib5e3CJcCuVJxY8jnq9vqwW5gGZJQLAN6HMFkQVbs',
  };
  Map<String, dynamic> body = {
    "collection": "VP_Collection",
    "database": "VP_Data",
    "dataSource": "AtlasCluster",
    "filter": {
      "Object-Type": "Vehicle-Details",
    },
  };
  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );
  var responseBody = jsonDecode(response.body);
  return responseBody['documents'] as List;
}

Future<bool> updateTheSwitch(String deviceAddress) async {
  String url =
      "https://ap-south-1.aws.data.mongodb-api.com/app/data-egfvn/endpoint/data/v1/action/updateOne";
  String apiKey =
      "r6ceRUK4eE7Iez5heqJyDalib5e3CJcCuVJxY8jnq9vqwW5gGZJQLAN6HMFkQVbs"; // Replace with your actual API key
  Map<String, dynamic> payload = {
    "collection": "VP_Collection",
    "database": "VP_Data",
    "dataSource": "AtlasCluster",
    "filter": {"ID": "MainSwitch", "Device Address": deviceAddress},
    "update": {
      "\$set": {"Switch": "ON"}
    }
  };

  HttpClient httpClient = HttpClient();
  try {
    Uri uri = Uri.parse(url);
    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('api-key', apiKey);
    request.add(utf8.encode(json.encode(payload)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    Map responseJson = jsonDecode(reply);
    if (responseJson["matchedCount"] == 0) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  } catch (e) {
    print("Error ");
  } finally {
    httpClient.close();
  }
  return Future.value(false);
}

Future<bool> updateTheValue(String DeviceAddress, String VehicleNumber,
    String EngineCapacity, String EngineStage, String Fuel) async {
  String url =
      "https://ap-south-1.aws.data.mongodb-api.com/app/data-egfvn/endpoint/data/v1/action/updateOne";
  String apiKey =
      "r6ceRUK4eE7Iez5heqJyDalib5e3CJcCuVJxY8jnq9vqwW5gGZJQLAN6HMFkQVbs";
  Map<String, dynamic> payload = {
    "collection": "VP_Collection",
    "database": "VP_Data",
    "dataSource": "AtlasCluster",
    "filter": {
      "Object-Type": "Vehicle-Details",
      "Device Address": DeviceAddress,
    },
    "update": {
      "\$set": {
        "Vehicle Number": VehicleNumber,
        "Engine Capacity": EngineCapacity,
        "Engine Stage": EngineStage,
        "Fuel": Fuel
      }
    },
  };

  HttpClient httpClient = HttpClient();
  try {
    Uri uri = Uri.parse(url);
    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('api-key', apiKey);
    request.add(utf8.encode(json.encode(payload)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    if (response.statusCode == 200) {
      print(reply);
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  } catch (e) {
    print("Error");
  } finally {
    httpClient.close();
  }
  return Future.value(true);
}

Future<Map> getVehicleDetails(String VehicleNumber) async {
  String url =
      "https://ap-south-1.aws.data.mongodb-api.com/app/data-egfvn/endpoint/data/v1/action/findOne";
  Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, PUT, POST, DELETE',
    'Access-Control-Allow-Headers':
        'Origin, X-Requested-With, Content-Type, Accept',
    'Access-Control-Request-Headers': '*',
    'api-key':
        'r6ceRUK4eE7Iez5heqJyDalib5e3CJcCuVJxY8jnq9vqwW5gGZJQLAN6HMFkQVbs',
  };
  Map<String, dynamic> body = {
    "collection": "VP_Vehicles",
    "database": "VP_Vehicles",
    "dataSource": "AtlasCluster",
    "filter": {"Vehicle Number": VehicleNumber, "Tokenized": "No"},
  };
  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );
  var responseBody = jsonDecode(response.body);
  return responseBody as Map;
}

void main() async {
  updateTheValue("BAV", 'GJ08BH3021', "2779", "BS6", "Petrol");
}
