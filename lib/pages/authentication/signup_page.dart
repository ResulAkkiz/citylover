import 'dart:io';

import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/custom_theme.dart';
import 'package:citylover/app_contants/string_generator.dart';
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
  int choose = 0;
  @override
  void initState() {
    super.initState();
  }

  Map<String, IconData> genderMap = {
    'Erkek': Icons.male,
    'Kadın': Icons.female,
  };

  DateTime birthdate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final placeViewModel = Provider.of<PlaceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: GestureDetector(
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
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: (userPhoto != null
                                    ? FileImage(userPhoto!)
                                    : const AssetImage(
                                        'assets/images/im_profile.png'))
                                as ImageProvider,
                            radius: 64,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Visibility(
                              visible: isErrorVisible,
                              child: const Center(
                                child: Text(
                                  'Lütfen profilinize profil fotoğrafı ekleyiniz.',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextFormField(
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
                              hintText: 'İsim', labelText: 'İsim'),
                        ),
                        TextFormField(
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
                              hintText: 'Soyisim', labelText: 'Soyisim'),
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
                          decoration: const InputDecoration(
                              hintText: 'E-mail', labelText: 'E-mail'),
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
                            hintText: 'Şifre',
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
                            const Text(
                              'Cinsiyet seçiniz.',
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.2,
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
                                              : Colors.white,
                                          size: 45,
                                        ),
                                        Text(
                                          entry.key,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: choose == index
                                                  ? Colors.black
                                                  : Colors.white,
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
                                if (userPhoto != null) {
                                  formKey.currentState!.save();
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
                                              child: CircularProgressIndicator(
                                                color: twitterBlue,
                                              ),
                                            ));
                                      },
                                    );
                                    UserModel? userModel =
                                        await userViewModel.createEmailPassword(
                                            email: emailController.text,
                                            password: passwordController.text,
                                            birthdate: birthdate,
                                            name: nameController.text,
                                            surname: surnameController.text,
                                            userGender: choose.toString(),
                                            lastCountry: placeViewModel.country,
                                            lastState: placeViewModel.city,
                                            userProfilePict:
                                                await userViewModel.uploadFile(
                                                    getRandomString(12),
                                                    'profilephoto',
                                                    userPhoto!));
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
                                  isErrorVisible = false;
                                } else {
                                  isErrorVisible = true;
                                  setState(() {});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const StadiumBorder()),
                              child: const Text('Üye Ol'),
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
