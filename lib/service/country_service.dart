import 'package:citylover/models/country_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_excel/excel.dart';

class CountryService {
  // Future<List<LocationModel>> fetchDataCountry() async {
  //   var headers = {
  //     'X-CSCAPI-KEY': 'T0sxZ093MGp6TjFjZDRZdEhtc3RjYkRkWUkyeXJySXJKODhmaGl0MQ=='
  //   };

  //   var request = http.Request(
  //       'GET', Uri.parse('https://api.countrystatecity.in/v1/countries'));

  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();
  //   List<LocationModel> result = [];
  //   if (response.statusCode == 200) {
  //     result = locationsFromMap(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }

  //   return result;
  // }

  Future<List<LocationModel>> loadCountries() async {
    final bytes = await rootBundle.load('assets/tables/countryTable.xlsx');
    final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
    final sheet = excel['country'];
    final column = <LocationModel>[];
    for (var row in sheet.rows) {
      column.add(LocationModel(
          id: row[0]!.value.toString(), name: row[2]!.value.toString()));
    }
    column.removeAt(0); // remove the header row
    return column;
  }

  Future<List<LocationModel>> loadStates(String countryID) async {
    final bytes = await rootBundle.load('assets/tables/stateTable.xlsx');
    final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
    final sheet = excel['zone'];
    final column = <LocationModel>[];

    for (var row in sheet.rows) {
      if (row[1]!.value.toString() == countryID) {
        column.add(LocationModel(
            id: row[0]!.value.toString(), name: row[2]!.value.toString()));
      }
    }
    // column.removeAt(0); // remove the header row
    return column;
  }
}
