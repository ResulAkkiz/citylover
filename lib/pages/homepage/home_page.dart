import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/custom_theme.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/models/commentmodel.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/addsharing/add_sharing_page.dart';
import 'package:citylover/pages/homepage/widgets/drawer_widget.dart';
import 'package:citylover/pages/profilepage/other_profile_page.dart';
import 'package:citylover/pages/sharingdetail/detail_sharing_page.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/user_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSharingListReady = false;
  bool isUserReady = false;
  UserModel? user;
  late PlaceViewModel placeViewModel;
  List<SharingModel> sharingList = [];
  @override
  void initState() {
    getSharingsbyLocation();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    placeViewModel = Provider.of<PlaceViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Uyarı'),
                      content: const Text(
                          'Uygulamadan çıkmak istediğinize emin misiniz?'),
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
                    )) ??
            false;
      }, // kullanıcı
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: userViewModel.user != null,
          child: FloatingActionButton(
            backgroundColor: twitterBlue,
            child: const Icon(
              Icons.add_rounded,
              size: 48,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddSharingPage(),
              ));
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: twitterBlue,
          elevation: 0,
          centerTitle: true,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              '${placeViewModel.country?.name} / ${placeViewModel.city?.name}',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ),
        drawer: const DrawerWidget(),
        body: isSharingListReady
            ? RefreshIndicator(
                onRefresh: () async {
                  return await userViewModel.getSharingsbyLocation(
                      placeViewModel.country!.name, placeViewModel.city!.name);
                },
                child: SafeArea(
                  child: Center(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12.0),
                      itemBuilder: (context, index) {
                        SharingModel currentSharing =
                            userViewModel.sharingList[index];
                        return FutureBuilder<UserModel?>(
                            future:
                                userViewModel.readUser(currentSharing.userID),
                            builder: (BuildContext context,
                                AsyncSnapshot<UserModel?> snapshot) {
                              if (snapshot.hasData) {
                                var currentUser = snapshot.data;
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => DetailSharingPage(
                                          userModel: currentUser,
                                          sharingModel: currentSharing),
                                    ));
                                  },
                                  leading: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            OtherUserProfilePage(
                                                userID: currentUser.userID),
                                      ));
                                    },
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          currentUser!.userProfilePict!),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentSharing.sharingContent,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('HH:mm•dd/MM/yyyy')
                                                .format(
                                                    currentSharing.sharingDate),
                                            // '11:12 • 11/02/2023',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54,
                                            ),
                                          ),
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
                                                  future: userViewModel
                                                      .getCommentsList(
                                                          currentSharing
                                                              .sharingID),
                                                  builder: (context,
                                                      AsyncSnapshot snapshot) {
                                                    if (snapshot.hasData) {
                                                      List<CommentModel>
                                                          commentList =
                                                          snapshot.data;
                                                      int listLength =
                                                          commentList.length;
                                                      return Text(
                                                        listLength.toString(),
                                                        style: const TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 12,
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Center(
                                                          child: Text(snapshot
                                                              .error
                                                              .toString()));
                                                    } else {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                  }),
                                              Builder(
                                                builder: (context) {
                                                  if (userViewModel.user !=
                                                      null) {
                                                    if (currentSharing.userID !=
                                                        userViewModel
                                                            .user!.userID) {
                                                      return IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        onPressed: () async {
                                                          bool response =
                                                              await buildShowDialog(
                                                                      context,
                                                                      const Text(
                                                                          'Uyarı'),
                                                                      const Text(
                                                                          'Seçmiş olduğunuz paylaşımı, raporlamak istediğinizden emin misiniz ?')) ??
                                                                  false;
                                                          if (response) {
                                                            bool isSuccessful =
                                                                await userViewModel
                                                                    .reportSharing(
                                                                        currentSharing);
                                                            debugPrint(
                                                                isSuccessful
                                                                    .toString());
                                                            if (isSuccessful &&
                                                                mounted) {
                                                              buildShowModelBottomSheet(
                                                                  context,
                                                                  'Raporlama işlemi başarıyla gerçekleşti. İnceleme sonucu gerekli aksiyonlar alınacaktır.',
                                                                  Icons
                                                                      .report_problem);
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
                                                        padding:
                                                            EdgeInsets.zero,
                                                        onPressed: () async {
                                                          bool response =
                                                              await buildShowDialog(
                                                                      context,
                                                                      const Text(
                                                                          'Uyarı'),
                                                                      const Text(
                                                                          'Seçmiş olduğunuz paylaşımı, silmek istediğinizden emin misiniz ?')) ??
                                                                  false;

                                                          if (response) {
                                                            bool isSuccesful =
                                                                await userViewModel
                                                                    .deleteSharing(
                                                                        currentSharing);
                                                            if (isSuccesful &&
                                                                mounted) {
                                                              buildShowModelBottomSheet(
                                                                  context,
                                                                  'Paylaşım silme işlemi başarıyla gerçekleşti.',
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
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ).separated(const SizedBox(
                                    height: 8,
                                  )),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            });
                      },
                      itemCount: userViewModel.sharingList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(thickness: 1.2);
                      },
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> getSharingsbyLocation() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final placeViewModel = Provider.of<PlaceViewModel>(context, listen: false);
    if (userViewModel.user != null) {
      user = await userViewModel.readUser(userViewModel.user!.userID);
      isUserReady = true;
      placeViewModel.savePlace(
          cityName: user!.lastState!, countryName: user!.lastCountry!);
      placeViewModel.loadStates(user!.lastCountry!.id);
      setState(() {});
    }

    await userViewModel.getSharingsbyLocation(
        placeViewModel.country!.name, placeViewModel.city!.name);

    isSharingListReady = true;
  }
}
