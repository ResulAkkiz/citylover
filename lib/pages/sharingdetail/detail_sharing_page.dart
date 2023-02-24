// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/string_generator.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/models/commentmodel.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/profilepage/other_profile_page.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailSharingPage extends StatefulWidget {
  const DetailSharingPage(
      {super.key, required this.sharingModel, required this.userModel});
  final SharingModel sharingModel;
  final UserModel userModel;

  @override
  State<DetailSharingPage> createState() => _DetailSharingPageState();
}

class _DetailSharingPageState extends State<DetailSharingPage> {
  late SharingModel sharingModel;
  late UserViewModel userViewModel;
  late UserModel userModel;
  bool isCommentsReady = false;

  @override
  void initState() {
    sharingModel = widget.sharingModel;
    userModel = widget.userModel;
    getComments();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userViewModel = Provider.of<UserViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Visibility(
        visible: userViewModel.user != null,
        child: CommentBox(
          sharingModel: sharingModel,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Paylaşım',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      OtherUserProfilePage(userID: userModel.userID),
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(userModel.userProfilePict!),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${userModel.userName} ${userModel.userSurname}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${sharingModel.countryName} / ${sharingModel.cityName}', //'$country / $province',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              sharingModel.sharingContent,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              DateFormat('HH:mm•dd/MM/yyyy').format(sharingModel.sharingDate),
            ),
            const Divider(thickness: 1.2),
            isCommentsReady
                ? ListView.separated(
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CommentModel currentComment =
                          userViewModel.commentList[index];
                      return FutureBuilder(
                          future: userViewModel.readUser(currentComment.userID),
                          builder:
                              (context, AsyncSnapshot<UserModel?> snapshot) {
                            if (snapshot.hasData) {
                              var currentUser = snapshot.data;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      currentUser!.userProfilePict!),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${currentUser.userName} ${currentUser.userSurname}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Builder(
                                          builder: (context) {
                                            if (userViewModel.user != null) {
                                              if (currentComment.userID !=
                                                  userViewModel.user!.userID) {
                                                return IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    bool response =
                                                        await buildShowDialog(
                                                                context,
                                                                const Text(
                                                                    'Uyarı'),
                                                                const Text(
                                                                    'Seçmiş olduğunuz yorumu, raporlamak istediğinizden emin misiniz ?')) ??
                                                            false;

                                                    if (response) {
                                                      bool isSuccessful =
                                                          await userViewModel
                                                              .reportComment(
                                                                  currentComment);
                                                      if (isSuccessful &&
                                                          mounted) {
                                                        buildShowModelBottomSheet(
                                                            context,
                                                            'Raporlama işlemi başarıyla gerçekleşti. İnceleme sonucu gerekli aksiyonlar alınacaktır.',
                                                            Icons
                                                                .done_outlined);
                                                      }
                                                    }
                                                  },
                                                  constraints:
                                                      const BoxConstraints(),
                                                  icon: const Icon(
                                                    Icons
                                                        .report_problem_outlined,
                                                    size: 14,
                                                  ),
                                                );
                                              } else {
                                                return IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    bool response =
                                                        await buildShowDialog(
                                                                context,
                                                                const Text(
                                                                    'Uyarı'),
                                                                const Text(
                                                                    'Seçmiş olduğunuz yorumu, silmek istediğinizden emin misiniz ?')) ??
                                                            false;

                                                    if (response) {
                                                      bool isSuccesful =
                                                          await userViewModel
                                                              .deleteComment(
                                                                  currentComment
                                                                      .sharingID,
                                                                  currentComment
                                                                      .commentID);
                                                      if (isSuccesful &&
                                                          mounted) {
                                                        buildShowModelBottomSheet(
                                                            context,
                                                            'Yorum silme işlemi başarıyla gerçekleşti.',
                                                            Icons.check);
                                                      }
                                                    }
                                                  },
                                                  constraints:
                                                      const BoxConstraints(),
                                                  icon: const Icon(
                                                    Icons.clear,
                                                    size: 14,
                                                  ),
                                                );
                                              }
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      currentComment.commentContent,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm•dd/MM/yyyy')
                                          .format(currentComment.commentDate),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ).separated(
                                  const SizedBox(
                                    height: 4,
                                  ),
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          });
                    },
                    itemCount: userViewModel.commentList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(thickness: 1.2);
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  )
          ],
        ).separated(
          const SizedBox(
            height: 8,
          ),
        ),
      ),
    );
  }

  Future<void> getComments() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.getComments(sharingModel.sharingID);
    isCommentsReady = true;
  }
}

Future<bool?> buildShowDialog(
    BuildContext context, Widget title, Widget content) {
  return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: title,
            content: content,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Hayır')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Evet')),
            ],
          ));
}

class CommentBox extends StatefulWidget {
  const CommentBox({
    super.key,
    required this.sharingModel,
  });
  final SharingModel sharingModel;

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  late SharingModel sharingModel;
  bool iconIgnore = false;
  UserModel? user;
  bool isUserReady = false;
  @override
  void initState() {
    sharingModel = widget.sharingModel;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getUser();
    super.didChangeDependencies();
  }

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            bottom: 2.0,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextField(
                    maxLength: 350,
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
                      return Builder(builder: (context) {
                        Color color;
                        if (maxLength! - currentLength < 20 &&
                            maxLength - currentLength != 0) {
                          color = Colors.amber;
                        } else if (maxLength - currentLength == 0) {
                          color = Colors.red;
                        } else {
                          color = Colors.black54;
                        }
                        return Text(
                          '$currentLength / $maxLength',
                          style: TextStyle(color: color),
                        );
                      });
                    },
                    controller: commentController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 0, left: 4),
                      hintText: 'Yorumunu Paylaş',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Builder(builder: (context) {
                    return IgnorePointer(
                      ignoring: iconIgnore,
                      child: IconButton(
                        color: Colors.amber,
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                        onPressed: commentController.text.trim() != ''
                            ? () async {
                                iconIgnore = true;
                                setState(() {});
                                debugPrint(iconIgnore.toString());
                                bool isSuccessful =
                                    await userViewModel.addComment(
                                  CommentModel(
                                      status: true,
                                      commentID: getRandomString(15),
                                      sharingID: sharingModel.sharingID,
                                      userID: user!.userID,
                                      commentDate: DateTime.now(),
                                      commentContent: commentController.text),
                                );
                                if (isSuccessful && mounted) {
                                  buildShowModelBottomSheet(
                                      context,
                                      'Yorumunuz yayınlandı.',
                                      Icons.done_outlined);
                                  commentController.clear();
                                }
                                iconIgnore = false;
                              }
                            : null,
                      ),
                    );
                  }))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getUser() async {
    final userViewModel = Provider.of<UserViewModel>(context);
    if (userViewModel.user != null) {
      user = await userViewModel.readUser(userViewModel.user!.userID);
    }
    isUserReady = true;
    setState(() {});
  }
}




// FutureBuilder(
//                           future: userViewModel.readUser(currentComment.userID),
//                           builder:
//                               (context, AsyncSnapshot<UserModel?> snapshot) {
//                             if (snapshot.hasData) {
//                               var currentUser = snapshot.data;
//                               return ListTile(
//                                 leading: CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                       currentUser!.userProfilePict!),
//                                 ),
//                                 title: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${currentUser.userName} ${currentUser.userSurname} ',
//                                       style: const TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       currentComment.commentContent,
//                                       style: const TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                     Text(
//                                       DateFormat('HH:mm•dd/MM/yyyy')
//                                           .format(currentComment.commentDate),
//                                       style: const TextStyle(
//                                         fontSize: 10,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                   ],
//                                 ).separated(
//                                   const SizedBox(
//                                     height: 4,
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               return const CircularProgressIndicator();
//                             }
//                           })