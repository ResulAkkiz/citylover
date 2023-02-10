import 'dart:io';

import 'package:citylover/app_contants/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  int? choose;
  @override
  void initState() {
    super.initState();
  }

  Map<String, IconData> genderMap = {
    'Erkek': Icons.male,
    'Kadın': Icons.female,
  };

  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    'Lütfen profilinize profil fotoğrafı ekleyiniz.'),
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
                              onPressed: () {
                                if (userPhoto != null) {
                                  formKey.currentState!.save();
                                  if (formKey.currentState!.validate()) {
                                    debugPrint('Başarılı');
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

  Widget buildDateTimePicker({
    required IconData iconData,
    required BuildContext context,
    required void Function(DateTime) onSelected,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      onTap: () async {
        final date = await showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDatePickerMode: DatePickerMode.year,
            initialDate: DateTime.now().subtract(const Duration(days: 6 * 365)),
            firstDate: DateTime(1923),
            lastDate: DateTime.now().subtract(const Duration(days: 6 * 365)));
        if (date == null) return;
        controller.text = DateFormat('dd-MM-yyyy').format(date);
        onSelected(date);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Lütfen doğum tarihinizi giriniz.";
        }
        return null;
      },
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
}
