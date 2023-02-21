// ignore_for_file: public_member_api_docs, sort_constructors_first
class SharingModel {
  String sharingID;
  String userID;
  String countryName;
  String cityName;
  String sharingContent;
  DateTime sharingDate;
  bool status;
  SharingModel({
    required this.sharingID,
    required this.userID,
    required this.countryName,
    required this.cityName,
    required this.sharingContent,
    required this.sharingDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sharingID': sharingID,
      'userID': userID,
      'countryName': countryName,
      'cityName': cityName,
      'sharingContent': sharingContent,
      'sharingDate': sharingDate.millisecondsSinceEpoch,
      'status': status
    };
  }

  factory SharingModel.fromMap(Map<String, dynamic> map) {
    return SharingModel(
      sharingID: map['sharingID'] as String,
      userID: map['userID'] as String,
      countryName: map['countryName'] as String,
      cityName: map['cityName'] as String,
      sharingContent: map['sharingContent'] as String,
      status: map['status'] as bool,
      sharingDate:
          DateTime.fromMillisecondsSinceEpoch(map['sharingDate'] as int),
    );
  }

  @override
  String toString() {
    return 'SharingModel(sharingID: $sharingID, userID: $userID, countryName: $countryName, cityName: $cityName, sharingContent: $sharingContent, sharingDate: $sharingDate)';
  }
}
