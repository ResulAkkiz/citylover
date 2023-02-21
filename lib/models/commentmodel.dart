// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommentModel {
  String commentID;
  String sharingID;
  String userID;
  String commentContent;
  DateTime commentDate;
  bool status;

  CommentModel({
    required this.commentID,
    required this.sharingID,
    required this.userID,
    required this.commentContent,
    required this.commentDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentID': commentID,
      'sharingID': sharingID,
      'userID': userID,
      'commentContent': commentContent,
      'status': status,
      'commentDate': commentDate.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentID: map['commentID'] as String,
      commentContent: map['commentContent'] as String,
      sharingID: map['sharingID'] as String,
      userID: map['userID'] as String,
      status: map['status'] as bool,
      commentDate:
          DateTime.fromMillisecondsSinceEpoch(map['commentDate'] as int),
    );
  }

  @override
  String toString() {
    return 'CommentModel(commentID: $commentID, sharingID: $sharingID, userID: $userID, commentContent: $commentContent, commentDate: $commentDate)';
  }
}
