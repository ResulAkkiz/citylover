// ignore_for_file: public_member_api_docs, sort_constructors_first
class SharingModel {
  String sharingID;
  String userID;
  String userPict;
  String userName;
  String countryName;
  String cityName;
  String sharingContent;
  DateTime sharingDate;
  SharingModel({
    required this.sharingID,
    required this.userID,
    required this.userPict,
    required this.userName,
    required this.countryName,
    required this.cityName,
    required this.sharingContent,
    required this.sharingDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sharingID': sharingID,
      'userID': userID,
      'userPict': userPict,
      'userName': userName,
      'countryName': countryName,
      'cityName': cityName,
      'sharingContent': sharingContent,
      'sharingDate': sharingDate.millisecondsSinceEpoch,
    };
  }

  factory SharingModel.fromMap(Map<String, dynamic> map) {
    return SharingModel(
      sharingID: map['sharingID'] as String,
      userID: map['userID'] as String,
      userPict: map['userPict'] as String,
      userName: map['userName'] as String,
      countryName: map['countryName'] as String,
      cityName: map['cityName'] as String,
      sharingContent: map['sharingContent'] as String,
      sharingDate:
          DateTime.fromMillisecondsSinceEpoch(map['sharingDate'] as int),
    );
  }

  @override
  String toString() {
    return 'SharingModel(sharingID: $sharingID, userID: $userID, userPict: $userPict, userName: $userName, countryName: $countryName, cityName: $cityName, sharingContent: $sharingContent, sharingDate: $sharingDate)';
  }
}
