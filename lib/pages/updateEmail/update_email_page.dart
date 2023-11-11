import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/pages/landingpage/landing_page.dart';
import 'package:citylover/service/firebase_auth_service.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateEmailPage extends StatefulWidget {
  const UpdateEmailPage({super.key});

  @override
  State<UpdateEmailPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ClipRRect(
                    //     borderRadius: BorderRadius.circular(12.0),
                    //     child:
                    //         Image.asset('assets/images/im_city.png', scale: 5)),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Lütfen yeni e-mail adresinizi giriniz.";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Yeni E-mail', labelText: 'Yeni E-mail'),
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
                              !obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        formKey.currentState!.save();
                        if (formKey.currentState!.validate()) {
                          bool isSuccesful = await userViewModel.updateEmail(
                              emailController.text, passwordController.text);
                          if (isSuccesful) {
                            await userViewModel.updateUser(
                                userViewModel.firebaseUser!.userID,
                                {'userEmail': emailController.text});
                            await userViewModel.signOut();
                            if (mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LandingScreen()),
                                  (Route<dynamic> route) => false);
                              buildShowModelBottomSheet(
                                  context,
                                  'E-mail güncelleme işlemi başarıyla gerçekleşmiştir.',
                                  Icons.mail);
                            }
                          } else {
                            if (mounted) {
                              buildShowModelBottomSheet(
                                  context, errorMessage, Icons.dangerous);
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const StadiumBorder()),
                      child: const Text('E-Mail Güncelle'),
                    )
                  ],
                ).separated(const SizedBox(
                  height: 16,
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
