// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:citylover/models/commentmodel.dart';
import 'package:citylover/models/country_model.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/service/firebase_auth_service.dart';
import 'package:flutter/material.dart';

import '../service/firebase_db_service.dart';
import '../service/firebase_storage_service.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _firebaseUser;
  UserModel? _user;
  UserModel? get user => _user;
  UserModel? get firebaseUser => _firebaseUser;
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirebaseDbService firebaseDbService = FirebaseDbService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  UserViewModel() {
    debugPrint('userviewmodel constructor method tetiklendi');
    currentUser();
  }
  List<CommentModel> commentList = [];
  List<SharingModel> sharingList = [];

  Future<UserModel?> createEmailPassword({
    required String email,
    required String password,
    String? name,
    String? surname,
    DateTime? birthdate,
    String? userGender,
    String? userProfilePict,
    LocationModel? lastCountry,
    LocationModel? lastState,
  }) async {
    _firebaseUser = await firebaseAuthService.createEmailPassword(
      email: email,
      password: password,
      birthdate: birthdate,
      name: name,
      surname: surname,
      userGender: userGender,
      userProfilePict: userProfilePict,
      lastCountry: lastCountry,
      lastState: lastState,
    );
    notifyListeners();
    if (_firebaseUser != null) {
      firebaseDbService.saveUser(_firebaseUser!);
    }
    return _firebaseUser;
  }

  Future<UserModel?> currentUser() async {
    _firebaseUser = await firebaseAuthService.currentUser();
    notifyListeners();
    return _firebaseUser;
  }

  Future<UserModel?> signInEmailPassword(String email, String password) async {
    _firebaseUser =
        await firebaseAuthService.signInEmailPassword(email, password);
    notifyListeners();
    return _firebaseUser;
  }

  Future<bool?> signOut() async {
    _firebaseUser = null;
    notifyListeners();
    return await firebaseAuthService.signOut();
  }

  Future<bool> saveUser(UserModel user) async {
    return await firebaseDbService.saveUser(user);
  }

  Future<List<SharingModel>> getSharingsbyID(String userID) async {
    return await firebaseDbService.getSharingsbyID(userID);
  }

  Future<UserModel?> readUser(String userId) async {
    return await firebaseDbService.readUser(userId);
  }

  Future<bool> addSharing(SharingModel sharingModel) async {
    return await firebaseDbService.addSharing(sharingModel);
  }

  Future<bool> deleteComment(
    String sharingID,
    String commentID,
  ) async {
    bool isSuccesful = await firebaseDbService.deleteComment(
      sharingID,
      commentID,
    );
    getComments(sharingID);
    return isSuccesful;
  }

  Future<String> uploadFile(String userID, String fileType, File uploadedFile) {
    return firebaseStorageService.uploadFile(userID, fileType, uploadedFile);
  }

  Future<void> getSharingsbyLocation(
      String countryValue, String cityValue) async {
    sharingList =
        await firebaseDbService.getSharingsbyLocation(countryValue, cityValue);
    debugPrint(sharingList.length.toString());
    notifyListeners();
  }

  Future<bool> addComment(CommentModel commentModel) async {
    bool isSuccesful = await firebaseDbService.addComment(commentModel);
    getComments(commentModel.sharingID);
    return isSuccesful;
  }

  Future<void> getComments(String sharingID) async {
    commentList = await firebaseDbService.getComments(sharingID);
    notifyListeners();
  }

  Future<List<CommentModel>> getCommentsList(String sharingID) async {
    return await firebaseDbService.getComments(sharingID);
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> newMap) async {
    return firebaseDbService.updateUser(userId, newMap);
  }

  Future<bool> resetPassword(String email) async {
    return await firebaseAuthService.resetPassword(email);
  }

  Future<bool> updateEmail(String newEmail, String password) async {
    return await firebaseAuthService.updateEmail(newEmail, password);
  }

  Future<bool> deleteSharing(SharingModel sharingModel) async {
    bool isSuccesful = await firebaseDbService.deleteSharing(sharingModel);
    getSharingsbyLocation(sharingModel.countryName, sharingModel.cityName);
    return isSuccesful;
  }

  Future<bool> reportSharing(SharingModel sharingModel) async {
    return await firebaseDbService.reportSharing(sharingModel);
  }

  Future<bool> reportComment(CommentModel commentModel) async {
    return await firebaseDbService.reportComment(commentModel);
  }
}
