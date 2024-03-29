import 'package:citylover/locator/locator.dart';
import 'package:citylover/models/country_model.dart';
import 'package:citylover/service/country_service.dart';
import 'package:flutter/material.dart';

class PlaceViewModel extends ChangeNotifier {
  CountryService countryService = locator.get<CountryService>();
  LocationModel? _city;
  LocationModel? _country;
  LocationModel? get city => _city;
  LocationModel? get country => _country;
  List<LocationModel> countryNameList = [];
  List<LocationModel> stateNameList = [];

  void savePlace({
    required LocationModel cityName,
    required LocationModel countryName,
  }) {
    _city = cityName;
    _country = countryName;
    notifyListeners();
  }

  Future<void> loadCountries() async {
    countryNameList.clear();
    countryNameList = await countryService.loadCountries();
    notifyListeners();
  }

  Future<void> loadStates(String countryID) async {
    stateNameList.clear();
    stateNameList = await countryService.loadStates(countryID);
    notifyListeners();
  }

  Future<List<LocationModel>> loadTempStates(String countryID) async {
    return await countryService.loadStates(countryID);
  }
}
