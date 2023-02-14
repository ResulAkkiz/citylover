// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:citylover/models/commentmodel.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/service/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import '../service/firebase_db_service.dart';
import '../service/firebase_storage_service.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirebaseDbService firebaseDbService = FirebaseDbService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  UserViewModel() {
    debugPrint('userviewmodel constructor method tetiklendi');
    currentUser();
  }

  Future<UserModel?> createEmailPassword({
    required String email,
    required String password,
    String? name,
    String? surname,
    DateTime? birthdate,
    String? userGender,
    String? userProfilePict,
  }) async {
    _user = await firebaseAuthService.createEmailPassword(
      email: email,
      password: password,
      birthdate: birthdate,
      name: name,
      surname: surname,
      userGender: userGender,
      userProfilePict: userProfilePict,
    );
    notifyListeners();
    if (_user != null) {
      firebaseDbService.saveUser(_user!);
    }
    return _user;
  }

  Future<UserModel?> currentUser() async {
    _user = await firebaseAuthService.currentUser();
    notifyListeners();
    return _user;
  }

  Future<List<CommentModel>> getComments(String sharingID) async {
    return firebaseDbService.getComments(sharingID);
  }

  Future<UserModel?> signInEmailPassword(String email, String password) async {
    _user = await firebaseAuthService.signInEmailPassword(email, password);
    notifyListeners();
    return _user;
  }

  Future<bool?> signOut() async {
    _user = null;
    notifyListeners();
    return await firebaseAuthService.signOut();
  }

  Future<bool> saveUser(UserModel user) async {
    return await firebaseDbService.saveUser(user);
  }

  Future<UserModel?> readUser(String userId) async {
    return await firebaseDbService.readUser(userId);
  }

  Future<bool> addSharing(SharingModel sharingModel) async {
    return await firebaseDbService.addSharing(sharingModel);
  }

  Future<String> uploadFile(String userID, String fileType, File uploadedFile) {
    return firebaseStorageService.uploadFile(userID, fileType, uploadedFile);
  }

  Future<List<SharingModel>> getSharingsbyLocation(
      String countryName, String cityName) async {
    return firebaseDbService.getSharingsbyLocation(countryName, cityName);
  }

  Future<bool> addComment(CommentModel commentModel) {
    return firebaseDbService.addComment(commentModel);
  }
}
