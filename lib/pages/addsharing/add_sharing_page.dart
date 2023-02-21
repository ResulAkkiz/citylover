import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/custom_theme.dart';
import 'package:citylover/app_contants/string_generator.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
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

  bool isUserReady = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final placeViewModel = Provider.of<PlaceViewModel>(context);
    country = placeViewModel.country!.name;
    city = placeViewModel.city!.name;
    getUser();
    super.didChangeDependencies();
  }

  TextEditingController sharingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final placeViewModel = Provider.of<PlaceViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: isUserReady
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(user != null
                                  ? user!.userProfilePict!
                                  : 'https://w7.pngwing.com/pngs/980/304/png-transparent-computer-icons-user-profile-avatar-heroes-silhouette-avatar.png')),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user!.userName!} ${user!.userSurname!}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '$country / $city', //'$country / $province',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 24 * 8,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              fillColor: Theme.of(context).primaryColor,
                              filled: true),
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
                          controller: sharingController,
                          maxLines: 8,
                          maxLength: 350,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: sharingController.text.trim() != ''
                            ? () async {
                                bool? isSuccessful =
                                    await userViewModel.addSharing(SharingModel(
                                        sharingID: getRandomString(12),
                                        userID: user!.userID,
                                        countryName:
                                            placeViewModel.country!.name,
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
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: twitterBlue,
                            shape: const StadiumBorder()),
                        child: const Text(
                          'Paylaş',
                          style: TextStyle(color: Colors.white),
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
                )),
    );
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
