import 'dart:developer';

import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/string_generator.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/custom_model_sheet.dart';

class AddSharingPage extends StatefulWidget {
  const AddSharingPage({super.key});

  @override
  State<AddSharingPage> createState() => _AddSharingPageState();
}

class _AddSharingPageState extends State<AddSharingPage> {
  UserModel? user;
  String? country;
  String? city;
  bool buttonIgnore = false;

  AssetEntity? selectedAsset;
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> previewAssetList = [];
  List<AssetEntity> selectedAssetList = [];

  bool isUserReady = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    getAlbums();
  }

  Future<void> getAlbums() async {
    albumList = await MediaServices.loadAlbums(RequestType.common);

    selectedAlbum = albumList.first;

    log((selectedAlbum == null).toString());

    if (selectedAlbum != null) {
      log(selectedAlbum!.name.toString());
      assetList = await MediaServices.loadAssets(selectedAlbum!);
      previewAssetList = assetList.take(10).toList();
    }

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    final placeViewModel = Provider.of<PlaceViewModel>(context);
    country = placeViewModel.country!.name;
    city = placeViewModel.city!.name;
    getUser();
    super.didChangeDependencies();
  }

  void checkSelectedAsset(AssetEntity selectedAsset) {
    if (selectedAssetList.contains(selectedAsset)) {
      selectedAssetList.remove(selectedAsset);
      setState(() {});
    } else {
      if (selectedAssetList.length <= 4) {
        selectedAssetList.add(selectedAsset);
        setState(() {});
      }
    }
  }

  TextEditingController sharingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final placeViewModel = Provider.of<PlaceViewModel>(context);
    return Scaffold(
        bottomSheet: Container(
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black54, offset: Offset(-1, -1), blurRadius: 4)
          ]),
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedAssetList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedAssetList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                    margin: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            color: ThemeColors.primary300,
                                            width: 1)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14.0),
                                      child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: AssetEntityImage(
                                              selectedAssetList[index])),
                                    )),
                              ),
                              if (selectedAssetList
                                  .contains(selectedAssetList[index]))
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      selectedAssetList
                                          .remove(selectedAssetList[index]);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                            ],
                          );
                        },
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.black54,
                    )
                  ],
                ),
              SizedBox(
                height: 75,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                                color: ThemeColors.primary300, width: 1)),
                        child: Icon(
                          Icons.photo_camera_rounded,
                          color: ThemeColors.primary400,
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: previewAssetList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            InkWell(
                              onTap: () {
                                checkSelectedAsset(previewAssetList[index]);
                              },
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(19.0),
                                        border: Border.all(
                                            color: ThemeColors.primary300,
                                            width: 1)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: AssetEntityImage(
                                        previewAssetList[index],
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                            ),
                            if (selectedAssetList.contains(assetList[index]))
                              CircleAvatar(
                                backgroundColor: ThemeColors.primary300,
                                radius: 10,
                                child: Text(
                                  (selectedAssetList.indexOf(
                                              previewAssetList[index]) +
                                          1)
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              )
                          ],
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          enableDrag: false,
                          showDragHandle: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0)),
                          ),
                          isScrollControlled: true,
                          constraints: BoxConstraints.expand(
                              height: MediaQuery.sizeOf(context).height * 0.9),
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, outerSetState) => Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        enableDrag: false,
                                        showDragHandle: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.0)),
                                        ),
                                        isScrollControlled: true,
                                        constraints: BoxConstraints.expand(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.9),
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, innerSetState) =>
                                                Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "İptal Et",
                                                          style: TextStyle(
                                                              color: ThemeColors
                                                                  .primary400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: albumList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        onTap: () async {
                                                          selectedAlbum =
                                                              albumList[index];

                                                          assetList =
                                                              await MediaServices
                                                                  .loadAssets(
                                                                      selectedAlbum!);
                                                          outerSetState(() {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        title: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      12.0,
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                              albumList[index]
                                                                  .name),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "İptal Et",
                                              style: TextStyle(
                                                  color:
                                                      ThemeColors.primary400),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(selectedAlbum!.name),
                                              const Icon(
                                                  Icons.expand_more_rounded)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: assetList.length,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              mainAxisSpacing: 2,
                                              crossAxisSpacing: 2),
                                      itemBuilder: (context, index) {
                                        AssetEntity currentAsset =
                                            assetList[index];
                                        return Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                checkSelectedAsset(
                                                    assetList[index]);
                                                outerSetState(
                                                  () {},
                                                );
                                              },
                                              child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: AssetEntityImage(
                                                      fit: BoxFit.cover,
                                                      currentAsset)),
                                            ),
                                            if (selectedAssetList
                                                .contains(assetList[index]))
                                              CircleAvatar(
                                                backgroundColor:
                                                    ThemeColors.primary300,
                                                radius: 10,
                                                child: Text(
                                                  (selectedAssetList.indexOf(
                                                              assetList[
                                                                  index]) +
                                                          1)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              border: Border.all(
                                  color: ThemeColors.primary300, width: 1)),
                          child: Icon(
                            Icons.photo_rounded,
                            color: ThemeColors.primary400,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        elevation: 8,
                        backgroundColor: ThemeColors.primary400,
                        shape: const StadiumBorder()),
                    onPressed: () {
                      _focusNode.unfocus();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Geri",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: buttonIgnore,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor: ThemeColors.primary400,
                          shape: const StadiumBorder()),
                      onPressed: sharingController.text.trim() != ''
                          ? () async {
                              buttonIgnore = true;
                              setState(() {});
                              bool? isSuccessful =
                                  await userViewModel.addSharing(SharingModel(
                                      sharingID: getRandomString(12),
                                      userID: user!.userID,
                                      countryName: placeViewModel.country!.name,
                                      cityName: placeViewModel.city!.name,
                                      sharingContent:
                                          sharingController.text.trim(),
                                      sharingDate: DateTime.now(),
                                      status: true));
                              if (isSuccessful && mounted) {
                                buildShowModelBottomSheet(
                                    context,
                                    'Paylaşım işlemi başarılı bir şekilde gerçekleşti.',
                                    Icons.done_outlined);
                                sharingController.clear();
                                Future.delayed(const Duration(seconds: 1)).then(
                                    (value) => Navigator.of(context)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomePage()),
                                            (Route<dynamic> route) => false));
                              }
                              buttonIgnore = false;
                            }
                          : null,
                      child: const Text(
                        "Gönder",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: isUserReady
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: CircleAvatar(
                            backgroundImage: AssetImage(ImageEnum.user.toPath)),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      flex: 9,
                      child: TextField(
                        autofocus: true,
                        maxLines: null,
                        focusNode: _focusNode,
                        onChanged: (value) {
                          setState(() {});
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              '[a-z A-Z á-ú Á-Ú 0-9 !@#%^&*(),.?":{}|<>]')),
                          FilteringTextInputFormatter.deny(RegExp('  +')),
                        ],
                        decoration: InputDecoration(
                            hintText: "Paylaşım yap...",
                            hintStyle:
                                TextStyle(color: ThemeColors.textGrey400),
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true),
                        controller: sharingController,
                      ),
                    )
                  ],
                ).separated(
                  const SizedBox(
                    height: 16,
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  Future<void> getUser() async {
    final userViewModel = Provider.of<UserViewModel>(context);
    if (userViewModel.user != null) {
      user = await userViewModel.readUser(userViewModel.user!.userID);
      isUserReady = true;
    }

    setState(() {});
  }
}

class MediaServices {
  static Future<List<AssetPathEntity>> loadAlbums(
      RequestType requestType) async {
    var permission = await Permission.storage.request();
    List<AssetPathEntity> albumList = [];
    if (permission.isGranted) {
      albumList = await PhotoManager.getAssetPathList(type: requestType);
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  static Future<List<AssetEntity>> loadAssets(
      AssetPathEntity selectedAlbum) async {
    List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(
        start: 0, end: await selectedAlbum.assetCountAsync);

    return assetList;
  }
}
