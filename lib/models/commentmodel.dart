class CommentModel {
  String commentID;
  String sharingID;
  String userID;
  String userPict;
  String userName;
  DateTime commentDate;
  CommentModel({
    required this.commentID,
    required this.sharingID,
    required this.userID,
    required this.userPict,
    required this.userName,
    required this.commentDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentID': commentID,
      'sharingID': sharingID,
      'userID': userID,
      'userPict': userPict,
      'userName': userName,
      'commentDate': commentDate.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentID: map['commentID'] as String,
      sharingID: map['sharingID'] as String,
      userID: map['userID'] as String,
      userPict: map['userPict'] as String,
      userName: map['userName'] as String,
      commentDate:
          DateTime.fromMillisecondsSinceEpoch(map['commentDate'] as int),
    );
  }

  @override
  String toString() {
    return 'CommentModel(commentID: $commentID, sharingID: $sharingID, userID: $userID, userPict: $userPict, userName: $userName, commentDate: $commentDate)';
  }
}
