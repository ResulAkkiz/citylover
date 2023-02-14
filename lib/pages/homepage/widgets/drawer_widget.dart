import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/custom_clipper.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/authentication/login_page.dart';
import 'package:citylover/pages/authentication/signup_page.dart';
import 'package:citylover/pages/profilepage/profile_page.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool isUserReady = false;
  UserModel? user;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  @override
  void didChangeDependencies() async {
    // final placeViewModel = Provider.of<PlaceViewModel>(context);
    // countryValue = placeViewModel.country ?? '';
    // stateValue = placeViewModel.city ?? '';
    final userViewModel = Provider.of<UserViewModel>(context);
    if (userViewModel.user != null) {
      user = await userViewModel.readUser(userViewModel.user!.userID);
    }

    isUserReady = true;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return SafeArea(
      child: Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: isUserReady
              ? SingleChildScrollView(
                  child: Column(children: [
                    Stack(
                      fit: StackFit.loose,
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        ClipPath(
                          clipper: MyCustomClipper(),
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ));
                                  },
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(user != null
                                        ? user!.userProfilePict!
                                        : 'https://w7.pngwing.com/pngs/980/304/png-transparent-computer-icons-user-profile-avatar-heroes-silhouette-avatar.png'),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 5,
                                child: Text(
                                  user != null
                                      ? '${user!.userName!} ${user!.userSurname!}'
                                      : 'Anonim Kullanıcı',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ).separated(const SizedBox(
                            width: 12,
                          )),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            CSCPicker(
                              layout: Layout.vertical,
                              showStates: true,
                              showCities: false,
                              flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                              dropdownDecoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff000000),
                                  width: 1.3,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                              ),
                              disabledDropdownDecoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.grey.shade300,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              countrySearchPlaceholder: "Ülke",
                              stateSearchPlaceholder: "Şehir",
                              citySearchPlaceholder: "İlçe",
                              countryDropdownLabel: "*Ülke",
                              stateDropdownLabel: "*Şehir",
                              cityDropdownLabel: "*İlçe",
                              selectedItemStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              dropdownHeadingStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                              dropdownItemStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              dropdownDialogRadius: 10.0,
                              searchBarRadius: 10.0,
                              onCountryChanged: (value) {
                                setState(() {
                                  countryValue = value;
                                });
                              },
                              onCityChanged: (value) {},
                              onStateChanged: (value) {
                                setState(() {
                                  stateValue = value ?? '';
                                });
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const StadiumBorder()),
                              child: const Text('Lokasyonu Değiştir'),
                            )
                          ],
                        ).separated(
                          const SizedBox(
                            height: 16,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: user != null
                          ? Column(
                              children: [
                                ListTile(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfilePage(),
                                      ));
                                    },
                                    iconColor: Colors.black,
                                    tileColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    leading: const Icon(Icons.person),
                                    title: const Text(
                                      'Profil Sayfası',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )),
                                ListTile(
                                    onTap: () {
                                      userViewModel.signOut();
                                    },
                                    iconColor: Colors.black,
                                    tileColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    leading: const Icon(Icons.logout),
                                    title: const Text(
                                      'Oturum Kapat',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ))
                              ],
                            ).separated(const SizedBox(
                              height: 8,
                            ))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupPage(),
                                      ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        shape: const StadiumBorder()),
                                    child: const Text('Üye Ol'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        shape: const StadiumBorder()),
                                    child: const Text('Oturum Aç'),
                                  )
                                ]).separated(const SizedBox(
                              width: 16,
                            )),
                    )
                  ]),
                )
              : const Center(child: CircularProgressIndicator())),
    );
  }
}
