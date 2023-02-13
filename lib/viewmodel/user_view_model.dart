// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:citylover/models/usermodel.dart';
import 'package:citylover/service/firebase_auth_service.dart';

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
  Future<UserModel?> currentUser() async {
    _user = await firebaseAuthService.currentUser();
    notifyListeners();
    return _user;
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
}
