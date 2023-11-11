// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/common_widgets/custom_back_button.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/models/commentmodel.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/homepage/home_page.dart';
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
      extendBodyBehindAppBar: true,
      extendBody: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomSheet: Visibility(
        visible: userViewModel.firebaseUser != null,
        child: CommentBox(
          user: userModel,
          sharingModel: sharingModel,
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: const EdgeInsets.only(left: 12),
          color: Colors.transparent,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    minHeight: kToolbarHeight,
                    minWidth: MediaQuery.sizeOf(context).width * 0.50,
                    maxWidth: MediaQuery.sizeOf(context).width * 0.70,
                  ),
                  decoration: BoxDecoration(
                      color: ThemeColors.primary400,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.elliptical(50, 50))),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      '${sharingModel.cityName} / ${sharingModel.countryName}',
                      style: TextStyle(
                          shadows: [
                            BoxShadow(
                                color: ThemeColors.textGrey400,
                                offset: const Offset(1, 1))
                          ],
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top), //Status bar height
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox.square(
                dimension: kToolbarHeight - 10,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.elliptical(25, 25),
                        topLeft: Radius.elliptical(25, 25)),
                    color: ThemeColors.background200,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          color: ThemeColors.background400,
                          offset: const Offset(2, 2))
                    ],
                    border:
                        Border.all(width: 2, color: ThemeColors.background500)),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OtherUserProfilePage(
                                    userID: userModel.userID),
                              ));
                            },
                            child: CircleAvatar(
                              radius: 36,
                              backgroundImage:
                                  AssetImage(ImageEnum.user.toPath),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${userModel.userName!} ${userModel.userSurname!}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sharingModel.sharingContent,
                            style: TextStyle(
                              color: ThemeColors.textGrey400,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SharingDateWidget(currentSharing: sharingModel),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.comment,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  FutureBuilder(
                                      future: userViewModel.getCommentsList(
                                          sharingModel.sharingID),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          List<CommentModel> commentList =
                                              snapshot.data;
                                          int listLength = commentList.length;
                                          return Text(
                                            listLength.toString(),
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  snapshot.error.toString()));
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  Builder(
                                    builder: (context) {
                                      if (userViewModel.firebaseUser != null) {
                                        if (sharingModel.userID !=
                                            userViewModel
                                                .firebaseUser!.userID) {
                                          return IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              bool response = await buildShowDialog(
                                                      context,
                                                      const Text('Uyarı'),
                                                      const Text(
                                                          'Seçmiş olduğunuz paylaşımı, raporlamak istediğinizden emin misiniz ?')) ??
                                                  false;
                                              if (response) {
                                                bool isSuccessful =
                                                    await userViewModel
                                                        .reportSharing(
                                                            sharingModel);
                                                debugPrint(
                                                    isSuccessful.toString());
                                                if (isSuccessful && mounted) {
                                                  buildShowModelBottomSheet(
                                                      context,
                                                      'Raporlama işlemi başarıyla gerçekleşti. İnceleme sonucu gerekli aksiyonlar alınacaktır.',
                                                      Icons.report_problem);
                                                }
                                              }
                                            },
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(
                                              Icons.report_problem_outlined,
                                              size: 14,
                                            ),
                                          );
                                        } else {
                                          return IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              bool response = await buildShowDialog(
                                                      context,
                                                      const Text('Uyarı'),
                                                      const Text(
                                                          'Seçmiş olduğunuz paylaşımı, silmek istediğinizden emin misiniz ?')) ??
                                                  false;

                                              if (response) {
                                                bool isSuccesful =
                                                    await userViewModel
                                                        .deleteSharing(
                                                            sharingModel);
                                                if (isSuccesful && mounted) {
                                                  buildShowModelBottomSheet(
                                                      context,
                                                      'Paylaşım silme işlemi başarıyla gerçekleşti.',
                                                      Icons.check);
                                                }
                                              }
                                            },
                                            constraints: const BoxConstraints(),
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
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SharingImageWidget()
                        ],
                      ).separated(const SizedBox(
                        height: 8,
                      )),
                    ),
                    const Flexible(flex: 1, child: DetailRateButtonsWidget()),
                  ],
                ),
              ),
              const Divider(thickness: 1.2),
              isCommentsReady
                  ? ListView.separated(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        CommentModel currentComment =
                            userViewModel.commentList[index];
                        return FutureBuilder(
                            future:
                                userViewModel.readUser(currentComment.userID),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              if (userViewModel.firebaseUser !=
                                                  null) {
                                                if (currentComment.userID !=
                                                    userViewModel
                                                        .firebaseUser!.userID) {
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
  const CommentBox({super.key, required this.sharingModel, required this.user});
  final SharingModel sharingModel;
  final UserModel user;

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  late SharingModel sharingModel;
  late UserModel user;

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    user = widget.user;
    sharingModel = widget.sharingModel;
    _focusNode.addListener(() {
      print("Tetiklendi");
      _isFocused = _focusNode.hasFocus;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build oldu");

    return _isFocused
        ? FocusedCommentBox(
            focusNode: _focusNode,
            sharing: sharingModel,
            user: user,
          )
        : NotFocusedCommentBox(
            user: user,
            focusNode: _focusNode,
          );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

class FocusedCommentBox extends StatefulWidget {
  const FocusedCommentBox(
      {super.key,
      required this.sharing,
      required this.user,
      required this.focusNode});

  final UserModel user;
  final SharingModel sharing;
  final FocusNode focusNode;

  @override
  State<FocusedCommentBox> createState() => _FocusedCommentBoxState();
}

class _FocusedCommentBoxState extends State<FocusedCommentBox> {
  late UserModel user;
  late SharingModel sharing;
  late FocusNode focusNode;
  String? commentBoxText;
  @override
  void initState() {
    super.initState();
    user = widget.user;
    sharing = widget.sharing;
    focusNode = widget.focusNode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(user.userProfilePict ?? ImageEnum.user.toPath),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '${user.userName!} ${user.userSurname!}',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Text(
                  '@${sharing.userID.substring(0, 6)}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ThemeColors.primary400),
                ),
                Text(
                  ' kullanicisina yanıt olarak',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ThemeColors.textGrey300),
                ),
              ],
            ),
          ),
          TextFormField(
            focusNode: focusNode,
            decoration: InputDecoration(
                hintText: "Yanıtını gönder",
                hintStyle: TextStyle(color: ThemeColors.textGrey300)),
            onChanged: (value) {
              setState(() {
                commentBoxText = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(Icons.image),
                color: ThemeColors.primary300,
              ),
              ElevatedButton(
                onPressed: commentBoxText == null || commentBoxText!.isEmpty
                    ? null
                    : () {
                        //  bool isSuccessful = await userViewModel.addComment(
                        //         CommentModel(
                        //             status: true,
                        //             commentID: getRandomString(15),
                        //             sharingID: sharingModel.sharingID,
                        //             userID: user!.userID,
                        //             commentDate: DateTime.now(),
                        //             commentContent: commentController.text),
                        //       );
                        //       if (isSuccessful && mounted) {
                        //         buildShowModelBottomSheet(context,
                        //             'Yorumunuz yayınlandı.', Icons.done_outlined);
                        //         commentController.clear();
                        //       }
                      },
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: ThemeColors.primary400),
                child: const Text(
                  "Yanıtla",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class NotFocusedCommentBox extends StatelessWidget {
  const NotFocusedCommentBox({
    super.key,
    required this.user,
    required FocusNode focusNode,
  }) : _focusNode = focusNode;

  final UserModel? user;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flex(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 1,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      user!.userProfilePict ?? ImageEnum.user.toPath),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 8,
                child: TextFormField(
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                      hintText: "Yorum yaz..",
                      hintStyle: TextStyle(color: ThemeColors.textGrey300)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailRateButtonsWidget extends StatelessWidget {
  const DetailRateButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: ThemeColors.primary200),
                color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.expand_less_rounded,
                  color: ThemeColors.primary200,
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '1453',
                    softWrap: false,
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: ThemeColors.primary200),
                  ),
                )
              ],
            )),
        const SizedBox(
          height: 12,
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Colors.red.shade200),
              color: Colors.white),
          child: Column(
            children: [
              Icon(
                Icons.expand_more_rounded,
                color: Colors.red.shade200,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  '763',
                  softWrap: false,
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade200),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
      ],
    );
  }
}
