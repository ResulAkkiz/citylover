import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchDataCountry() async {
  final response = await http.get(
      Uri.parse(
          'https://parseapi.back4app.com/classes/Country?limit=250&keys=name'),
      headers: {
        "X-Parse-Application-Id":
            "mxsebv4KoWIGkRntXwyzg6c6DhKWQuit8Ry9sHja", // This is the fake app's application id
        "X-Parse-Master-Key":
            "TpO0j3lG2PmEVMXlKYQACoOXKQrL3lwM0HwR9dbH" // This is the fake app's readonly master key
      });
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<Map<String, dynamic>> fetchDataCities() async {
  final response = await http.get(
      Uri.parse(
          'https://parseapi.back4app.com/classes/City?limit=250&order=name&include=country&keys=name,country,country.name'),
      headers: {
        "X-Parse-Application-Id":
            "mxsebv4KoWIGkRntXwyzg6c6DhKWQuit8Ry9sHja", // This is the fake app's application id
        "X-Parse-Master-Key":
            "TpO0j3lG2PmEVMXlKYQACoOXKQrL3lwM0HwR9dbH" // This is the fake app's readonly master key
      });
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch data');
  }
}
