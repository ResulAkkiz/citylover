import 'package:citylover/models/commentmodel.dart';
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
    sharingList.sort((b, a) => a.sharingDate.compareTo(b.sharingDate));
    return sharingList;
  }

  Future<List<SharingModel>> getSharingsbyID(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection('sharingsbyuser').doc(userID).get();
    Map<String, dynamic>? sharingMap = querySnapshot.data();
    List<SharingModel> sharingList = [];

    if (sharingMap != null) {
      for (Map<String, dynamic> element in sharingMap.values) {
        sharingList.add(SharingModel.fromMap(element));
      }
    }

    return sharingList;
  }

  Future<bool> addComment(CommentModel commentModel) async {
    Map<String, dynamic> commentMap = commentModel.toMap();
    await firestore
        .collection('comments')
        .doc(commentModel.sharingID)
        .set({commentModel.commentID: commentMap}, SetOptions(merge: true));
    return true;
  }

  Future<List<CommentModel>> getComments(String sharingID) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firestore.collection('comments').doc(sharingID).get();
    Map<String, dynamic>? commentsMap = documentSnapshot.data();
    List<CommentModel> commentList = [];
    if (commentsMap != null) {
      for (Map<String, dynamic> element in commentsMap.values) {
        commentList.add(CommentModel.fromMap(element));
      }
    }
    commentList.sort((a, b) => a.commentDate.compareTo(b.commentDate));
    return commentList;
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
    await firestore
        .collection('sharingsbyuser')
        .doc(sharingModel.userID)
        .set({sharingModel.sharingID: sharingMap}, SetOptions(merge: true));

    return true;
  }

  Future<bool> deleteSharing(SharingModel sharingModel) async {
    await firestore
        .collection('sharings')
        .doc(sharingModel.countryName)
        .collection(sharingModel.cityName)
        .doc(sharingModel.sharingID)
        .delete();

    await firestore
        .collection('sharingsbyuser')
        .doc(sharingModel.userID)
        .update({sharingModel.sharingID: FieldValue.delete()});

    return true;
  }

  Future<bool> deleteComment(String sharingID, String commentID) async {
    firestore
        .collection('comments')
        .doc(sharingID)
        .update({commentID: FieldValue.delete()});
    return true;
  }
}
