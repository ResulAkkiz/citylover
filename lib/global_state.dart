import 'dart:developer';

import 'package:citylover/models/country_model.dart';
import 'package:citylover/models/usermodel.dart';

class GlobalState {
  UserModel? _user;
  LocationModel? _country;
  LocationModel? _state;

  static final GlobalState _instance = GlobalState._internal();

  factory GlobalState() {
    return _instance;
  }

  GlobalState._internal();

  UserModel? get user => _user;
  LocationModel? get country => _country;
  LocationModel? get state => _state;

  set user(UserModel? newUser) {
    if (_user != newUser) {
      _user = newUser;
      log("Global State User changed");
    }
  }

  set country(LocationModel? newCountry) {
    if (_country != newCountry) {
      _country = newCountry;
      log("Global State Country changed");
    }
  }

  set state(LocationModel? newState) {
    if (_state != newState) {
      _state = newState;
      log("Global State State changed");
    }
  }
}
