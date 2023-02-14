import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/string_generator.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
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
  String country = 'Türkiye';
  String city = 'Ankara';

  bool isUserReady = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getUser();
    super.didChangeDependencies();
  }

  TextEditingController sharingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
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
                                      userPict: user!.userProfilePict!,
                                      userName: user!.userName!,
                                      countryName: 'Türkiye',
                                      cityName: 'Bilecik',
                                      sharingContent: sharingController.text,
                                      sharingDate: DateTime.now(),
                                      userSurname: user!.userSurname!));
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
                          backgroundColor: Colors.white,
                          shape: const StadiumBorder()),
                      child: const Text('Paylaş'),
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
    debugPrint(user.toString());

    setState(() {});
  }
}
