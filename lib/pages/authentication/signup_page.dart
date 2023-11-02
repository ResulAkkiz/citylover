import 'dart:io';

import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/custom_theme.dart';
import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/string_generator.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/common_widgets/datetime_picker_widget.dart';
import 'package:citylover/models/usermodel.dart';
import 'package:citylover/service/firebase_auth_service.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/icon_elevated_button.dart';
import '../landingpage/landing_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  ImagePicker imagePicker = ImagePicker();
  bool isErrorVisible = false;
  File? userPhoto;
  int choose = 2;
  @override
  void initState() {
    super.initState();
  }

  Map<String, IconData> genderMap = {
    'Erkek': Icons.male,
    'Kadın': Icons.female,
    "Belirtmek İstemiyorum.": Icons.question_mark_rounded
  };

  DateTime birthdate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final placeViewModel = Provider.of<PlaceViewModel>(context);

    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  ImageEnum.pencil.toPath,
                  scale: 2,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.viewPaddingOf(context).top,
                              right: 12.0,
                              left: 12.0),
                          height: MediaQuery.sizeOf(context).height * 0.20,
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [BackButton()],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                shape: const BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                elevation: 8,
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.sizeOf(context).width * 0.6),
                                backgroundColor: Theme.of(context).primaryColor,
                                context: context,
                                builder: (context) {
                                  return ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                          Icons.camera,
                                          color: Colors.white,
                                        ),
                                        title: const Text(
                                          'Kamera',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          _kameradanCek();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      const Divider(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.photo_album,
                                            color: Colors.white),
                                        title: const Text('Galeri',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                        onTap: () {
                                          _galeridenSec();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeColors.background300),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: (userPhoto != null
                                          ? FileImage(userPhoto!)
                                          : AssetImage(ImageEnum.user.toPath))
                                      as ImageProvider,
                                  radius: 48,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeColors.background300),
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(20),
                                  ],
                                  keyboardType: TextInputType.name,
                                  controller: nameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Lütfen isminizi giriniz.";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'İsim',
                                  ),
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 15,
                              ),
                              Flexible(
                                child: TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                  ],
                                  keyboardType: TextInputType.name,
                                  controller: surnameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Lütfen soyisminizi giriniz.";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Soyisim'),
                                ),
                              )
                            ],
                          ),
                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(35),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Lütfen e-mail adresinizi giriniz.";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration:
                                const InputDecoration(labelText: 'E-mail'),
                          ),
                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(12),
                            ],
                            controller: passwordController,
                            obscureText: obscurePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Lütfen şifrenizi giriniz.";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  }
                                },
                                child: Icon(
                                    obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black),
                              ),
                            ),
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
                                  birthdate = date;
                                });
                              },
                              controller: birthdateController,
                              iconData: Icons.date_range,
                              context: context),
                          Column(
                            children: [
                              Chip(
                                side: BorderSide(
                                    width: 1.5, color: ThemeColors.primary400),
                                backgroundColor: ThemeColors.background100,
                                label: const Text(
                                  'Cinsiyet seçiniz.',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: genderMap.entries.map((entry) {
                                  int index = genderMap.values
                                      .toList()
                                      .indexOf(entry.value);
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        choose = index;
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: choose == index
                                                    ? ThemeColors.primary400
                                                    : Colors.black,
                                                blurRadius: 4,
                                                offset: const Offset(2, 2))
                                          ],
                                          borderRadius: const BorderRadius.only(
                                              bottomRight:
                                                  Radius.elliptical(25, 25),
                                              topLeft:
                                                  Radius.elliptical(25, 25)),
                                          color: ThemeColors.background100,
                                          border: Border.all(
                                              width: 2,
                                              color: ThemeColors.primary300)),
                                      width: MediaQuery.sizeOf(context).width *
                                          0.23,
                                      height: MediaQuery.sizeOf(context).width *
                                          0.23,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            entry.value,
                                            color: choose == index
                                                ? ThemeColors.primary400
                                                : Colors.black,
                                            size: 35,
                                          ),
                                          Text(
                                            entry.key,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: choose == index
                                                    ? ThemeColors.primary400
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: IconElevatedButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white, // İkon rengi
                                    size: 18, // İkon boyutu
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24.0),
                                              topRight: Radius.circular(24.0)),
                                        ),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: twitterBlue,
                                                ),
                                              ));
                                        },
                                      );
                                      UserModel? userModel = await userViewModel
                                          .createEmailPassword(
                                              email: emailController.text,
                                              password: passwordController.text,
                                              birthdate: birthdate,
                                              name: nameController.text.trim(),
                                              surname:
                                                  surnameController.text.trim(),
                                              userGender: choose.toString(),
                                              lastCountry:
                                                  placeViewModel.country,
                                              lastState: placeViewModel.city,
                                              userProfilePict: userPhoto != null
                                                  ? await userViewModel
                                                      .uploadFile(
                                                          getRandomString(12),
                                                          'profilephoto',
                                                          userPhoto!)
                                                  : null);
                                      if (userModel != null) {
                                        if (mounted) {
                                          Navigator.of(context).pop();
                                          Navigator.of(
                                                  context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LandingScreen()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        }
                                      } else {
                                        if (mounted) {
                                          Navigator.of(context).pop();
                                          buildShowModelBottomSheet(context,
                                              errorMessage, Icons.dangerous);
                                        }
                                        errorMessage = '';
                                      }
                                    }
                                  },
                                  text: "Üye Ol",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).separated(const SizedBox(
                        height: 16,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          elevation: 8,
          backgroundColor: ThemeColors.primary300,
          shape: const StadiumBorder()),
      onPressed: () {
        Navigator.maybePop(context);
      },
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white,
      ),
      label: const Text(
        "Geri",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }
}
