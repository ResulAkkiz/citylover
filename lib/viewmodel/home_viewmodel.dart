import 'dart:developer';

import 'package:citylover/global_state.dart';
import 'package:citylover/locator/locator.dart';
import 'package:citylover/models/country_model.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/service/firebase_db_service.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  // FirebaseStorageService firebaseStorageService =
  //     locator.get<FirebaseStorageService>();
  //   FirebaseAuthService firebaseAuthService = locator.get<FirebaseAuthService>();
  FirebaseDbService firebaseDbService = locator.get<FirebaseDbService>();
  GlobalState globalState = locator.get<GlobalState>();

  UserModel? _user;
  UserModel? get user => _user;

  LocationModel? _state;
  LocationModel? get state => _state;

  LocationModel? _country;
  LocationModel? get country => _country;

  List<SharingModel>? _homeSharingList;
  List<SharingModel>? get homeSharingList => _homeSharingList;

  final Map<SharingModel, int> _sharingCommentCount = {};
  Map<SharingModel, int> get sharingCommentCount => _sharingCommentCount;

  final Map<SharingModel, UserModel?> _sharingUserList = {};
  Map<SharingModel, UserModel?> get sharingUserList => _sharingUserList;

  HomeViewModel() {
    _user = globalState.user;
    _country = globalState.country;
    _state = globalState.state;
  }

  Future<UserModel?> readUser(String userId) async {
    return await firebaseDbService.readUser(userId);
  }

  Future<int> getCommentCount(String sharingID) async {
    return await firebaseDbService.getCommentCount(sharingID);
  }

  Future<void> getSharingsbyLocation() async {
    _homeSharingList = await firebaseDbService.getSharingsbyLocation(
        country!.name, state!.name);
    if (_homeSharingList != null) {
      for (SharingModel element in _homeSharingList!) {
        _sharingUserList[element] = await readUser(element.userID);
        _sharingCommentCount[element] =
            await getCommentCount(element.sharingID);
      }
      log(_homeSharingList!.length.toString());
    }
    notifyListeners();
  }

  Future<bool> deleteSharing(SharingModel sharingModel) async {
    bool isSuccesful = await firebaseDbService.deleteSharing(sharingModel);
    await getSharingsbyLocation();
    return isSuccesful;
  }

  Future<bool> reportSharing(SharingModel sharingModel) async {
    return await firebaseDbService.reportSharing(sharingModel);
  }
}
