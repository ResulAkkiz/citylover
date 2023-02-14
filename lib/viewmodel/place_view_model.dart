import 'package:flutter/material.dart';

class PlaceViewModel extends ChangeNotifier {
  String? _city;
  String? _country;

  String? get city => _city;
  String? get country => _country;

  void savePlace({
    required String cityName,
    required String countryName,
  }) {
    _city = cityName;
    _country = countryName;
    notifyListeners();
  }
}
