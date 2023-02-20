import 'dart:io';

import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/string_generator.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/pages/updateEmail/update_email_page.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  bool isUserReady = false;
  late DateTime dateTime;
  ImagePicker imagePicker = ImagePicker();
  File? userPhoto;
  int choose = 0;
  UserModel? user;
  List<SharingModel> sharingList = [];
  Map<String, IconData> genderMap = {
    'Erkek': Icons.male,
    'Kadın': Icons.female,
  };
  @override
  void initState() {
    getStarted();
    super.initState();
  }

  void _kameradanCek() async {
    var yeniResim = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (yeniResim != null) {
        userPhoto = (File(yeniResim.path));
      }
    });
  }

  void _galeridenSec() async {
    var yeniResim = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (yeniResim != null) {
        userPhoto = (File(yeniResim.path));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
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
          title: const Text('Profil Sayfası'),
        ),
        body: isUserReady
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Theme.of(context).primaryColor,
                              context: context,
                              builder: (context) {
                                return ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                      ),
                                      title: const Text('Kamera'),
                                      onTap: () {
                                        _kameradanCek();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_album,
                                          color: Colors.white),
                                      title: const Text('Galeri'),
                                      onTap: () {
                                        _galeridenSec();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: CircleAvatar(
                          radius: 58,
                          backgroundImage: userPhoto != null
                              ? FileImage(userPhoto!) as ImageProvider
                              : NetworkImage(user!.userProfilePict ??
                                  'https://randomuser.me/api/portraits/men/75.jpg'),
                        ),
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
                            TextFormField(
                              readOnly: true,
                              controller: emailController,
                              decoration: const InputDecoration(
                                  hintText: 'E-mail', labelText: 'E-mail'),
                            ),
                            buildDateTimePicker(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Lütfen doğum tarihinizi giriniz.";
                                  }
                                  return null;
                                },
                                onSelected: (DateTime date) {
                                  setState(() {
                                    dateTime = date;
                                  });
                                },
                                controller: birthdateController,
                                iconData: Icons.date_range,
                                context: context),
                            Column(
                              children: [
                                const Text(
                                  'Cinsiyet seçiniz.',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.8 *
                                              0.2,
                                      vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: genderMap.entries.map((entry) {
                                      int index = genderMap.values
                                          .toList()
                                          .indexOf(entry.value);
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            choose = index;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              entry.value,
                                              color: choose == index
                                                  ? Colors.black
                                                  : Colors.grey.shade400,
                                              size: 45,
                                            ),
                                            Text(
                                              entry.key,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: choose == index
                                                      ? Colors.black
                                                      : Colors.grey.shade400,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    formKey.currentState!.save();
                                    if (formKey.currentState!.validate()) {
                                      bool isSuccessful = await userViewModel
                                          .updateUser(user!.userID, {
                                        'userName': nameController.text,
                                        'userSurame': surnameController.text,
                                        'userBirthdate':
                                            dateTime.millisecondsSinceEpoch,
                                        'userGender': choose.toString(),
                                        'userProfilePict':
                                            await uploadProfilePhoto()
                                      });
                                      if (isSuccessful && mounted) {
                                        buildShowModelBottomSheet(
                                            context,
                                            'Profiliniz başarıyla güncellendi.',
                                            Icons.done_outlined);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: const StadiumBorder()),
                                  child: const Text('Profili Güncelle'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: const StadiumBorder()),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const UpdateEmailPage(),
                                    ));
                                  },
                                  child: const Text('E-Mail Güncelle'),
                                )
                              ],
                            ),
                          ],
                        ).separated(
                          const SizedBox(
                            height: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
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
                                  onTap: () {},
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user!.userProfilePict!),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  .format(currentSharing
                                                      .sharingDate),
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
                                  ));
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                thickness: 1.2,
                                color: Colors.white,
                              );
                            },
                            itemCount: sharingList.length),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget buildDateTimePicker({
    required IconData iconData,
    required BuildContext context,
    required void Function(DateTime) onSelected,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            color: Colors.black,
          ),
          hintText: controller.text == '' ? 'Doğum Tarihi' : controller.text,
          contentPadding: const EdgeInsets.fromLTRB(74, 12, 10, 12)),
    );
  }

  Future<String?> uploadProfilePhoto() async {
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    if (userPhoto != null) {
      return await userViewModel.uploadFile(
          getRandomString(12), 'profilephoto', userPhoto!);
    } else {
      return user?.userProfilePict;
    }
  }

  void getStarted() async {
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    if (userViewModel.user != null) {
      user = await userViewModel.readUser(userViewModel.user!.userID);
      nameController.text = user!.userName ?? '';
      surnameController.text = user!.userSurname ?? '';
      emailController.text = user!.userEmail;
      dateTime = user!.userBirthdate!;
      birthdateController.text = DateFormat('dd/MM/yyyy')
          .format(user?.userBirthdate ?? DateTime.now());

      choose = int.parse(user!.userGender ?? '0');
      sharingList =
          await userViewModel.getSharingsbyID(userViewModel.user!.userID);
      debugPrint(sharingList.toString());
    }
    isUserReady = true;
    setState(() {});
  }
}
