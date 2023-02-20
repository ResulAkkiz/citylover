import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/custom_clipper.dart';
import 'package:citylover/models/country_model.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/landingpage/landing_page.dart';
import 'package:citylover/pages/profilepage/profile_page.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool isUserReady = false;
  bool isCountryReady = false;
  bool isStateReady = false;
  UserModel? user;
  late LocationModel? countryValue;
  late LocationModel? stateValue;
  List<LocationModel> stateList = [];
  late PlaceViewModel placeViewModel;
  @override
  void initState() {
    getValues();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  void getValues() async {
    final placeViewModel = Provider.of<PlaceViewModel>(context, listen: false);
    countryValue = placeViewModel.country;
    stateValue = placeViewModel.city;
    stateList = placeViewModel.stateNameList;

    setState(() {
      isCountryReady = true;
      isStateReady = true;
    });
  }

  @override
  void didChangeDependencies() {
    getUser();
    placeViewModel = Provider.of<PlaceViewModel>(context);
    super.didChangeDependencies();
  }

  Future<void> getUser() async {
    final userViewModel = Provider.of<UserViewModel>(context);
    if (userViewModel.user != null) {
      user = await userViewModel.readUser(userViewModel.user!.userID);
    }
    isUserReady = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
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
                                  Navigator.of(context).push(MaterialPageRoute(
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
                                    fontSize: 24, fontWeight: FontWeight.w500),
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
                          isCountryReady
                              ? DropdownButtonFormField<LocationModel>(
                                  isExpanded: true,
                                  hint: const Text('Ülke'),
                                  value: countryValue,
                                  items: placeViewModel.countryNameList
                                      .map((LocationModel value) {
                                    return DropdownMenuItem<LocationModel>(
                                      value: value,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                  onChanged: (LocationModel? model) async {
                                    if (model != null) {
                                      isStateReady = false;
                                      stateList = await placeViewModel
                                          .loadTempStates(model.id);
                                      countryValue = model;
                                      stateValue = stateList.isNotEmpty
                                          ? stateList.first
                                          : null;

                                      isStateReady = true;
                                    }
                                    setState(() {});
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          isStateReady
                              ? DropdownButtonFormField<LocationModel>(
                                  isExpanded: true,
                                  value: stateValue,
                                  hint: const Text('Şehir'),
                                  items: stateList.map((LocationModel value) {
                                    return DropdownMenuItem<LocationModel>(
                                      value: value,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                  onChanged: (model) {
                                    stateValue = model;
                                    setState(() {});
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          ElevatedButton(
                            onPressed: (countryValue != null &&
                                    stateValue != null)
                                ? () {
                                    placeViewModel.stateNameList = stateList;
                                    placeViewModel.savePlace(
                                        cityName: stateValue!,
                                        countryName: countryValue!);
                                    userViewModel.getSharingsbyLocation(
                                        countryValue!.name, stateValue!.name);
                                    if (userViewModel.user != null) {
                                      userViewModel.updateUser(
                                          userViewModel.user!.userID, {
                                        'lastState': stateValue?.toMap(),
                                        'lastCountry': countryValue?.toMap(),
                                      });
                                    }
                                  }
                                : null,
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
                                    Navigator.pop(context);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )),
                              ListTile(
                                  onTap: () {
                                    userViewModel.signOut();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LandingScreen()),
                                        (Route<dynamic> route) => false);
                                  },
                                  iconColor: Colors.black,
                                  tileColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  leading: const Icon(Icons.logout),
                                  title: const Text(
                                    'Oturum Kapat',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
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
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LandingScreen()),
                                        (Route<dynamic> route) => false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: const StadiumBorder()),
                                  child: const Text('Üye Ol'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LandingScreen()),
                                        (Route<dynamic> route) => false);
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
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
