// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:citylover/models/country_model.dart';

class UserModel {
  String userID;
  String? userName;
  String? userSurname;
  String userEmail;
  DateTime? userBirthdate;
  String? userGender;
  String? userProfilePict;
  LocationModel? lastState;
  LocationModel? lastCountry;
  bool? status;
  UserModel({
    required this.userID,
    this.userName,
    this.userSurname,
    required this.userEmail,
    this.userBirthdate,
    this.userGender,
    this.userProfilePict,
    this.lastState,
    this.lastCountry,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'userName': userName,
      'userSurname': userSurname,
      'userEmail': userEmail,
      'userBirthdate': userBirthdate?.millisecondsSinceEpoch,
      'userGender': userGender,
      'userProfilePict': userProfilePict,
      'lastState': lastState?.toMap(),
      'lastCountry': lastCountry?.toMap(),
      'status': status
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] as String,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userSurname:
          map['userSurname'] != null ? map['userSurname'] as String : null,
      userEmail: map['userEmail'] as String,
      userBirthdate: map['userBirthdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['userBirthdate'] as int)
          : null,
      userGender:
          map['userGender'] != null ? map['userGender'] as String : null,
      userProfilePict: map['userProfilePict'] != null
          ? map['userProfilePict'] as String
          : null,
      lastCountry: map['lastCountry'] != null
          ? LocationModel.fromMap(map['lastCountry'])
          : null,
      lastState: map['lastState'] != null
          ? LocationModel.fromMap(map['lastState'])
          : null,
      status: map['status'] != null ? map['status'] as bool : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(userID: $userID, userName: $userName, userSurname: $userSurname, userEmail: $userEmail, userBirthdate: $userBirthdate, userGender: $userGender, userProfilePict: $userProfilePict, lastState: $lastState, lastCountry: $lastCountry)';
  }
}
