import 'package:citylover/models/commentmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseDbService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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

  Future<bool> addSharing(String userID, CommentModel comment) async {
    Map<String, dynamic> commentMap = comment.toMap();
    await firestore.collection('sharings').doc(userID.toString()).set(
        {comment.commentID.toString(): commentMap}, SetOptions(merge: true));

    return true;
  }
}
