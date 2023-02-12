import 'dart:io';

import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/common_widgets/datetime_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  TextEditingController passwordController = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool obscurePassword = true;
  ImagePicker imagePicker = ImagePicker();
  bool isErrorVisible = false;
  File? userPhoto;
  int choose = 0;
  Map<String, IconData> genderMap = {
    'Erkek': Icons.male,
    'Kadın': Icons.female,
  };

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil Sayfası'),
      ),
      body: SingleChildScrollView(
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
                child: const CircleAvatar(
                  radius: 58,
                  backgroundImage: NetworkImage(
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
                                  MediaQuery.of(context).size.width * 0.8 * 0.2,
                              vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: const StadiumBorder()),
                          child: const Text('Profili Güncelle'),
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
    );
  }
}
