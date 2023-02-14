import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDbService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> readAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').get();

    final allUser = snapshot.docs.map((doc) => doc.data()).toList();
    List<UserModel> userMapList = [];
    for (var user in allUser) {
      userMapList.add(UserModel.fromMap(user));
    }
    return userMapList;
  }

  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(userID).get();
    Map<String, dynamic>? userMap = snapshot.data();
    return UserModel.fromMap(userMap!);
  }

  Future<bool> saveUser(UserModel userModel) async {
    Map<String, dynamic> userMap = userModel.toMap();

    await firestore
        .collection('users')
        .doc(userModel.userID.toString())
        .set(userMap);
    return true;
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> newMap) async {
    firestore.collection('users').doc(userId).update(newMap);
    return true;
  }

  Future<bool> addSharing(SharingModel sharingModel) async {
    Map<String, dynamic> sharingMap = sharingModel.toMap();
    await firestore
        .collection('sharings')
        .doc(sharingModel.countryName)
        .collection(sharingModel.cityName)
        .doc(sharingModel.sharingID)
        .set(sharingMap);
    return true;
  }

  Future<List<SharingModel>> getSharingsbyLocation(
      String countryName, String cityName) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('sharings')
        .doc(countryName)
        .collection(cityName)
        .get();

    final allSharings = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<SharingModel> sharingList = [];
    for (Map<String, dynamic> singleSharing in allSharings) {
      sharingList.add(SharingModel.fromMap(singleSharing));
    }
    return sharingList;
  }
}
