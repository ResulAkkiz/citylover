import 'package:citylover/models/country_model.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String errorMessage = '';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserModel?> createEmailPassword({
    required String email,
    required String password,
    DateTime? birthdate,
    String? name,
    String? surname,
    String? userGender,
    String? userProfilePict,
    LocationModel? lastCountry,
    LocationModel? lastState,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      errorMessage = '';
      return userCredential.user != null
          ? UserModel(
              userID: userCredential.user!.uid,
              userEmail: userCredential.user!.email!,
              userName: name,
              userSurname: surname,
              userBirthdate: birthdate,
              userGender: userGender,
              userProfilePict: userProfilePict,
              lastCountry: lastCountry,
              lastState: lastState)
          : null;
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case 'invalid-email':
          errorMessage = 'Lütfen geçerli bir email adresi giriniz';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email zaten başka bir hesap tarafından kullanılıyor.';
          break;
        case 'weak-password':
          errorMessage = 'Lütfen daha güçlü bir parola giriniz.';
          break;
        default:
          errorMessage = 'Hata: ${ex.code}';
          debugPrint(ex.code);
      }
      return null;
    }
  }

  UserModel? userToUserModel(User? user) {
    if (user != null) {
      return UserModel(
        userID: user.uid,
        userEmail: user.email ?? '',
      );
    } else {
      return null;
    }
  }

  Future<UserModel?> currentUser() async {
    try {
      var user = firebaseAuth.currentUser;
      return userToUserModel(user);
    } catch (e) {
      debugPrint("CurrentUser Hatası: ${e.toString()}");
      return null;
    }
  }

  Future<UserModel?> signInEmailPassword(String email, String sifre) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: sifre);
      errorMessage = '';
      return userToUserModel(userCredential.user);
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case 'invalid-email':
          errorMessage = 'Lütfen geçerli bir email adresi giriniz';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email zaten başka bir hesap tarafından kullanılıyor.';
          break;
        case 'user-not-found':
          errorMessage = 'Kullanıcı bulunamadı.';
          break;
        case 'wrong-password':
          errorMessage = 'Lütfen parolanızı kontrol ediniz.';
          break;

        default:
      }
      return null;
    }
  }

  Future<bool?> signOut() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint("Singout Hatası: ${e.toString()}");
      return null;
    }
  }

  Future<bool?> updatePassword(String email) {
    throw UnimplementedError();
  }

  Future<bool?> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      debugPrint("resetPassword error: ${e.toString()}");
      return null;
    }
  }
}
