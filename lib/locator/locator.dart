import 'package:citylover/global_state.dart';
import 'package:citylover/service/country_service.dart';
import 'package:citylover/service/firebase_auth_service.dart';
import 'package:citylover/service/firebase_db_service.dart';
import 'package:citylover/service/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

//Uygulama başlar başlamaz, nesne üretimi olmuyor.Lazy olduğu için ihtiyaç duyulduğu an üretiliyor.
void setupLocator() {
  locator.registerLazySingleton(() => FirebaseDbService());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => CountryService());

  locator.registerLazySingleton(() => FirebaseFirestore.instance);
  locator.registerLazySingleton(() => FirebaseStorage.instance);
  locator.registerLazySingleton(() => FirebaseAuth.instance);

  locator.registerLazySingleton(() => GlobalState());
}
