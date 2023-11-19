import 'dart:developer';

import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/pages/addsharing/add_sharing_page.dart';
import 'package:citylover/pages/homepage/widgets/drawer_widget.dart';
import 'package:citylover/pages/profilepage/other_profile_page.dart';
import 'package:citylover/pages/sharingdetail/detail_sharing_page.dart';
import 'package:citylover/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    log("Homepage Build.");
    final homeViewModel = Provider.of<HomeViewModel>(context);
    homeViewModel.getSharingsbyLocation();

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
        extendBodyBehindAppBar: true,
        floatingActionButton: Visibility(
          visible: homeViewModel.user != null,
          child: const FloatingActionButton(),
        ),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: const EdgeInsets.only(left: 12),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DrawerButton(),
                  LocationTitleWidget(homeViewModel)
                ],
              ),
            ),
          ),
        ),
        drawer: const DrawerWidget(),
        body: RefreshIndicator(
          onRefresh: () async {
            return await homeViewModel.getSharingsbyLocation();
          },
          child: SafeArea(
            child: Center(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                itemCount: homeViewModel.homeSharingList.length,
                itemBuilder: (context, index) {
                  SharingModel currentSharing =
                      homeViewModel.homeSharingList[index];
                  var currentUser =
                      homeViewModel.sharingUserList[currentSharing];

                  var listLength =
                      homeViewModel.sharingCommentCount[currentSharing];
                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        margin: const EdgeInsets.only(bottom: 20, top: 10),
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
                            border: Border.all(
                                width: 2, color: ThemeColors.background500)),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailSharingPage(
                                  userModel: currentUser!,
                                  sharingModel: currentSharing),
                            ));
                          },
                          leading: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OtherUserProfilePage(
                                    userID: currentUser!.userID),
                              ));
                            },
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: (currentUser != null &&
                                      currentUser.userProfilePict != null)
                                  ? NetworkImage(currentUser.userProfilePict!)
                                  : AssetImage(ImageEnum.user.toPath)
                                      as ImageProvider,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentSharing.sharingContent,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: ThemeColors.textGrey400,
                                  fontSize: 15,
                                ),
                                maxLines: 3,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SharingDateWidget(
                                      currentSharing: currentSharing),
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
                                      Text(
                                        listLength.toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                      ReportDeleteButtonWidget(
                                          homeViewModel, currentSharing)
                                    ],
                                  ),
                                ],
                              ),
                              const SharingImageWidget()
                            ],
                          ).separated(const SizedBox(
                            height: 0,
                          )),
                        ),
                      ),
                      const RateButtonsWidget()
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportDeleteButtonWidget extends StatefulWidget {
  const ReportDeleteButtonWidget(this._homeViewModel, this._sharingModel,
      {super.key});
  final SharingModel _sharingModel;
  final HomeViewModel _homeViewModel;

  @override
  State<ReportDeleteButtonWidget> createState() =>
      _ReportDeleteButtonWidgetState();
}

class _ReportDeleteButtonWidgetState extends State<ReportDeleteButtonWidget> {
  late HomeViewModel _homeViewModel;
  late SharingModel _sharingModel;
  @override
  void initState() {
    _homeViewModel = widget._homeViewModel;
    _sharingModel = widget._sharingModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_homeViewModel.user != null) {
      if (_sharingModel.userID != _homeViewModel.user!.userID) {
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
                  await _homeViewModel.reportSharing(_sharingModel);
              debugPrint(isSuccessful.toString());
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
                  await _homeViewModel.deleteSharing(_sharingModel);
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
  }
}

class FloatingActionButton extends StatelessWidget {
  const FloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(minHeight: 90, minWidth: 90),
      padding: EdgeInsets.zero,
      icon: Image.asset(
        ImageEnum.paper.toPath,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddSharingPage(),
        ));
      },
    );
  }
}

class LocationTitleWidget extends StatelessWidget {
  const LocationTitleWidget(this._homeViewModel, {super.key});

  final HomeViewModel _homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 36, right: 24),
      constraints: BoxConstraints(
        minHeight: kToolbarHeight,
        minWidth: MediaQuery.sizeOf(context).width * 0.50,
        maxWidth: MediaQuery.sizeOf(context).width * 0.70,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.primary400,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.elliptical(50, 50),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          '${_homeViewModel.country?.name} / ${_homeViewModel.state?.name}',
          style: TextStyle(
              shadows: [
                BoxShadow(
                    color: ThemeColors.textGrey400, offset: const Offset(1, 1))
              ],
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
    );
  }
}

class SharingDateWidget extends StatelessWidget {
  const SharingDateWidget({
    super.key,
    required this.currentSharing,
  });

  final SharingModel currentSharing;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('HH:mm•dd/MM/yyyy').format(currentSharing.sharingDate),
      style: const TextStyle(
        fontSize: 10,
        color: Colors.black54,
      ),
    );
  }
}

class SharingImageWidget extends StatelessWidget {
  const SharingImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            "https://firebasestorage.googleapis.com/v0/b/wonderwander-d7833.appspot.com/o/sharingPics%2Fthumbnail%2FProfile_photo.png?alt=media&token=b91286f8-d04d-4fe4-af8c-7c9415f7dbde&_gl=1*19d1hps*_ga*MzUyODUzOTM0LjE2OTA2MjY5MjM.*_ga_CW55HF8NVT*MTY5ODk5Nzk1MC41Ni4xLjE2OTg5OTc5NTIuNTguMC4w",
            width: 35,
            height: 35,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            "https://firebasestorage.googleapis.com/v0/b/wonderwander-d7833.appspot.com/o/sharingPics%2Fthumbnail%2FProfile_photo.png?alt=media&token=b91286f8-d04d-4fe4-af8c-7c9415f7dbde&_gl=1*19d1hps*_ga*MzUyODUzOTM0LjE2OTA2MjY5MjM.*_ga_CW55HF8NVT*MTY5ODk5Nzk1MC41Ni4xLjE2OTg5OTc5NTIuNTguMC4w",
            width: 35,
            height: 35,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            "https://firebasestorage.googleapis.com/v0/b/wonderwander-d7833.appspot.com/o/sharingPics%2Fthumbnail%2FProfile_photo.png?alt=media&token=b91286f8-d04d-4fe4-af8c-7c9415f7dbde&_gl=1*19d1hps*_ga*MzUyODUzOTM0LjE2OTA2MjY5MjM.*_ga_CW55HF8NVT*MTY5ODk5Nzk1MC41Ni4xLjE2OTg5OTc5NTIuNTguMC4w",
            width: 35,
            height: 35,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            "https://firebasestorage.googleapis.com/v0/b/wonderwander-d7833.appspot.com/o/sharingPics%2Fthumbnail%2FProfile_photo.png?alt=media&token=b91286f8-d04d-4fe4-af8c-7c9415f7dbde&_gl=1*19d1hps*_ga*MzUyODUzOTM0LjE2OTA2MjY5MjM.*_ga_CW55HF8NVT*MTY5ODk5Nzk1MC41Ni4xLjE2OTg5OTc5NTIuNTguMC4w",
            width: 35,
            height: 35,
          ),
        ),
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: ThemeColors.textGrey200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              "+3",
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: ThemeColors.textGrey400),
            ),
          ),
        )
      ],
    ).separated(const SizedBox(
      width: 4,
    ));
  }
}

class RateButtonsWidget extends StatelessWidget {
  const RateButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: ThemeColors.background500),
                color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.expand_less_rounded,
                  color: ThemeColors.background500,
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '1453',
                    softWrap: false,
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: ThemeColors.background500),
                  ),
                )
              ],
            )),
        const SizedBox(
          width: 12,
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

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ThemeColors.primary400,
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white)),
          child: const Icon(
            Icons.list,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}
