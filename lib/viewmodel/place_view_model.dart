import 'package:citylover/models/country_model.dart';
import 'package:citylover/service/country_service.dart';
import 'package:flutter/material.dart';

class PlaceViewModel extends ChangeNotifier {
  String? _city;
  String? _country;

  String? get city => _city;
  String? get country => _country;

  CountryService countryService = CountryService();
  List<LocationModel> countryList = [];
  List<LocationModel> stateList = [];

  void savePlace({
    required String cityName,
    required String countryName,
  }) {
    _city = cityName;
    _country = countryName;
    notifyListeners();
  }

  Future<void> fetchDataCountry() async {
    countryList = await countryService.fetchDataCountry();
    notifyListeners();
  }

  Future<void> fetchDataState(String countryCode) async {
    stateList = await countryService.fetchDataStates(countryCode);
    notifyListeners();
  }
}
