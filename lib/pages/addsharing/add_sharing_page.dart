import 'dart:developer';
import 'dart:io';

import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/multistyle_textcontroller.dart';
import 'package:citylover/app_contants/string_generator.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/common_widgets/custom_back_button.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/viewmodel/add_sharing_viewmodel.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

  late ImagePicker imagePicker = ImagePicker();
  final ScrollController _controller = ScrollController();
  final ValueNotifier<String> contentText = ValueNotifier("");
  final MultiStyleTextEditingController _textcontroller =
      MultiStyleTextEditingController();

  bool isUserReady = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    log("InitState");
  }

  @override
  void deactivate() {
    final sharingViewModel =
        Provider.of<AddSharingViewModel>(context, listen: false);
    sharingViewModel.resetIndexValues();
    if (_textcontroller.text.isNotEmpty) {
      sharingViewModel.contentText = _textcontroller.text;
    }

    log("Deactive");

    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    log("Dispose");
    super.dispose();
  }

  void _scrollListener() {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.position.pixels;
    if (maxScroll == currentScroll) {
      getAssetfromAlbum();
    }
  }

  void getAssetfromAlbum() async {
    final sharingViewModel =
        Provider.of<AddSharingViewModel>(context, listen: false);

    await sharingViewModel.getAssetfromAlbum();
  }

  @override
  void didChangeDependencies() {
    final placeViewModel = Provider.of<PlaceViewModel>(context);
    final sharingViewModel = Provider.of<AddSharingViewModel>(context);

    if (_textcontroller.text.isEmpty) {
      _textcontroller.text = sharingViewModel.contentText;
    }
    if (country == null || city == null) {
      country = placeViewModel.country!.name;
      city = placeViewModel.city!.name;
    }
    if (user == null) {
      getUser();
    }

    log("DidChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    log("Build");
    final userViewModel = Provider.of<UserViewModel>(context);
    final placeViewModel = Provider.of<PlaceViewModel>(context);

    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black54, offset: Offset(-1, -1), blurRadius: 4)
            ]),
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SelectedAssetWidget(),
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
                          child: IconButton(
                            onPressed: () {
                              _kameradanCek();
                            },
                            icon: const Icon(Icons.photo_camera_rounded),
                            color: ThemeColors.primary400,
                          ),
                        ),
                      ),
                      const PreviewAssetWidget(),
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
                                height:
                                    MediaQuery.sizeOf(context).height * 0.9),
                            context: context,
                            builder: (context) {
                              return Column(
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
                                          return Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
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
                                              AlbumListWidget(
                                                  controller: _controller)
                                            ],
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
                                              Consumer<AddSharingViewModel>(
                                                builder: (context,
                                                    sharingViewModel, child) {
                                                  log("Selected Asset Consumer.");
                                                  return Text(sharingViewModel
                                                      .selectedAlbum!.name);
                                                },
                                              ),
                                              const Icon(
                                                  Icons.expand_more_rounded)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Consumer<AddSharingViewModel>(
                                      builder:
                                          (context, sharingViewModel, child) {
                                        log("Grid Asset Consumer");
                                        return SingleChildScrollView(
                                          controller: _controller,
                                          child: Column(
                                            children: [
                                              GridView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: sharingViewModel
                                                    .assetList.length,
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 2,
                                                        crossAxisSpacing: 2),
                                                itemBuilder: (context, index) {
                                                  AssetEntity currentAsset =
                                                      sharingViewModel
                                                          .assetList[index];
                                                  return Stack(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          sharingViewModel
                                                              .selectAsset(
                                                                  sharingViewModel
                                                                          .assetList[
                                                                      index]);
                                                        },
                                                        child: AspectRatio(
                                                          aspectRatio: 1,
                                                          child:
                                                              AssetEntityImage(
                                                            currentAsset,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      if (sharingViewModel
                                                          .selectedAssetList
                                                          .contains(
                                                              currentAsset))
                                                        Positioned.fill(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  ThemeColors
                                                                      .primary300,
                                                              radius: 10,
                                                              child: Text(
                                                                (sharingViewModel
                                                                            .selectedAssetList
                                                                            .indexOf(currentAsset) +
                                                                        1)
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      if (currentAsset.type ==
                                                          AssetType.video)
                                                        const Positioned.fill(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Icon(
                                                              Icons
                                                                  .videocam_rounded,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      if (currentAsset.type ==
                                                          AssetType.video)
                                                        Positioned.fill(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          4),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black54,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              24)),
                                                              child: Text(
                                                                currentAsset
                                                                    .duration
                                                                    .formatSecond(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  );
                                                },
                                              ),
                                              if (sharingViewModel.loadMore)
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child:
                                                        CupertinoActivityIndicator(
                                                      color: ThemeColors
                                                          .primary500,
                                                    ))
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
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
                  const CustomBackButton(),
                  ValueListenableBuilder(
                    valueListenable: contentText,
                    builder: (context, text, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 8,
                            backgroundColor: ThemeColors.primary400,
                            shape: const StadiumBorder()),
                        onPressed: text.trim() != '' &&
                                text.trim().length <= 1000
                            ? () async {
                                bool? isSuccessful =
                                    await userViewModel.addSharing(SharingModel(
                                        sharingID: getRandomString(12),
                                        userID: user!.userID,
                                        countryName:
                                            placeViewModel.country!.name,
                                        cityName: placeViewModel.city!.name,
                                        sharingContent: text.trim(),
                                        sharingDate: DateTime.now(),
                                        status: true));
                                if (isSuccessful && mounted) {
                                  buildShowModelBottomSheet(
                                      context,
                                      'Paylaşım işlemi başarılı bir şekilde gerçekleşti.',
                                      Icons.done_outlined);
                                  text = "";
                                  Future.delayed(const Duration(seconds: 1))
                                      .then((value) => Navigator.of(context)
                                          .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePage()),
                                              (Route<dynamic> route) => false));
                                }
                              }
                            : null,
                        child: const Text(
                          "Gönder",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      );
                    },
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: CircleAvatar(
                          backgroundImage: AssetImage(ImageEnum.user.toPath)),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        maxLines: null,
                        onChanged: (value) {
                          contentText.value = value;
                        },
                        controller: _textcontroller,
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
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true),
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

  void _kameradanCek() async {
    final sharingViewModel =
        Provider.of<AddSharingViewModel>(context, listen: false);
    var yeniResim = await imagePicker.pickImage(source: ImageSource.camera);
    var assetEntity = await convertXFiletoAssetEntity(yeniResim);
    sharingViewModel.selectAsset(assetEntity!);
    sharingViewModel.insertImagetoPreviewList(assetEntity);
  }

  Future<AssetEntity?> convertXFiletoAssetEntity(XFile? xfile) async {
    final fileData = await xfile!.readAsBytes();
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${xfile.name}');
    await tempFile.writeAsBytes(fileData);
    AssetEntity? assetEntity;
    final savedFile = await PhotoManager.editor.saveImage(
      fileData,
      title: xfile.name,
    );
    if (savedFile != null) {
      assetEntity = savedFile;
    }

    await tempFile.delete();
    return assetEntity;
  }

  Future<void> getUser() async {
    final userViewModel = Provider.of<UserViewModel>(context);
    if (userViewModel.firebaseUser != null) {
      user = await userViewModel.readUser(userViewModel.firebaseUser!.userID);
      isUserReady = true;
    }

    setState(() {});
  }
}

class AlbumListWidget extends StatelessWidget {
  const AlbumListWidget({
    super.key,
    required ScrollController controller,
  }) : _controller = controller;

  final ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<AddSharingViewModel>(
        builder: (context, sharingViewModel, child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: sharingViewModel.albumList.length,
            itemBuilder: (context, index) {
              final currentAlbum = sharingViewModel.albumList[index];
              return ListTile(
                onTap: () async {
                  sharingViewModel.updateSelectedAlbum = currentAlbum;
                  sharingViewModel.getAssetfromAlbum();

                  Navigator.pop(context);

                  _controller.animateTo(
                    0,
                    duration:
                        const Duration(milliseconds: 500), // Animasyon süresi
                    curve: Curves.easeInOut, // Animasyon eğrisi
                  );
                },
                title: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 4.0),
                  child: Text(currentAlbum.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PreviewAssetWidget extends StatelessWidget {
  const PreviewAssetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddSharingViewModel>(
      builder: (context, sharingViewModel, child) {
        log("Preview Asset Consumer.");
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: sharingViewModel.previewAssetList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final currentPreviewAsset =
                sharingViewModel.previewAssetList[index];
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    sharingViewModel.selectAsset(currentPreviewAsset);
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19.0),
                            border: Border.all(
                                color: ThemeColors.primary300, width: 1)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18.0),
                          child: AssetEntityImage(
                            sharingViewModel.previewAssetList[index],
                            isOriginal: false,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                ),
                if (sharingViewModel.selectedAssetList
                    .contains(currentPreviewAsset))
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        backgroundColor: ThemeColors.primary300,
                        radius: 10,
                        child: Text(
                          (sharingViewModel.selectedAssetList
                                      .indexOf(currentPreviewAsset) +
                                  1)
                              .toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                if (currentPreviewAsset.type == AssetType.video)
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.videocam_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                if (currentPreviewAsset.type == AssetType.video)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(24)),
                        child: Text(
                          currentPreviewAsset.duration.formatSecond(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        );
      },
    );
  }
}

class SelectedAssetWidget extends StatelessWidget {
  const SelectedAssetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddSharingViewModel>(
      builder: (context, sharingViewModel, child) {
        log("Selected Asset Consumer");
        return sharingViewModel.selectedAssetList.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: sharingViewModel.selectedAssetList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final currentSelectedAsset =
                            sharingViewModel.selectedAssetList[index];
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                  margin: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: ThemeColors.primary300,
                                          width: 1)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: AssetEntityImage(
                                      currentSelectedAsset,
                                      isOriginal: false, // Defaults to `true`.
                                      thumbnailSize: const ThumbnailSize.square(
                                          50), // Preferred value.
                                      thumbnailFormat: ThumbnailFormat
                                          .jpeg, // Defaults to `jpeg`.

                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                            if (sharingViewModel.selectedAssetList
                                .contains(currentSelectedAsset))
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    sharingViewModel.removefromSelectedAsset(
                                        currentSelectedAsset);
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
              )
            : const SizedBox.shrink();
      },
    );
  }
}
