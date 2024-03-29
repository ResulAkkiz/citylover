import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/pages/sharingdetail/detail_sharing_page.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OtherUserProfilePage extends StatefulWidget {
  const OtherUserProfilePage({super.key, required this.userID});
  final String userID;
  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  bool isUserReady = false;
  UserModel? user;
  List<SharingModel> sharingList = [];

  @override
  void initState() {
    getStarted(widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: isUserReady
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 58,
                      backgroundImage: NetworkImage(user!.userProfilePict ??
                          'https://randomuser.me/api/portraits/men/75.jpg'),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Lütfen isminizi giriniz.";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'İsim', labelText: 'İsim'),
                          ),
                          TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.name,
                            controller: surnameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Lütfen soyisminizi giriniz.";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Soyisim', labelText: 'Soyisim'),
                          ),
                        ],
                      ).separated(
                        const SizedBox(
                          height: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            SharingModel currentSharing = sharingList[index];
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DetailSharingPage(
                                        sharingModel: currentSharing,
                                        userModel: user!),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user!.userProfilePict!),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${currentSharing.countryName} / ${currentSharing.cityName}', //'$country / $province',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    currentSharing.sharingContent,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('HH:mm•dd/MM/yyyy')
                                            .format(currentSharing.sharingDate),
                                        // '11:12 • 11/02/2023',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ).separated(const SizedBox(
                                height: 8,
                              )),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              thickness: 4,
                              color: Colors.white,
                            );
                          },
                          itemCount: sharingList.length),
                    )
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void getStarted(String userID) async {
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);

    user = await userViewModel.readUser(userID);
    nameController.text = user!.userName ?? '';
    surnameController.text = user!.userSurname ?? '';
    sharingList = await userViewModel.getSharingsbyID(userID);
    isUserReady = true;
    setState(() {});
  }
}
