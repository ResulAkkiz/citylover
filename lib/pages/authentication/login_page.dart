import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/custom_theme.dart';
import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/common_widgets/custom_back_button.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/common_widgets/icon_elevated_button.dart';
import 'package:citylover/pages/landingpage/landing_page.dart';
import 'package:citylover/pages/resetPassword/reset_password_page.dart';
import 'package:citylover/service/firebase_auth_service.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: const EdgeInsets.only(left: 12),
          color: Colors.white,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    minHeight: kToolbarHeight,
                    minWidth: MediaQuery.sizeOf(context).width * 0.50,
                    maxWidth: MediaQuery.sizeOf(context).width * 0.70,
                  ),
                  decoration: BoxDecoration(
                      color: ThemeColors.primary400,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.elliptical(50, 50))),
                  child: const Text(
                    "Oturum Aç",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.bottomLeft,
            constraints:
                BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
            color: Colors.white,
            child: Image.asset(
              ImageEnum.signin.toPath,
              scale: 1.8,
            ),
          ),
          Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Column(
                        children: [
                          TextFormField(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
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
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetPasswordPage(),
                                    ));
                                  },
                                  child: const Text(
                                    'Şifremi unuttum...',
                                    style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          ),
                          IconElevatedButton(
                              text: 'Giriş Yap',
                              onPressed: () async {
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
                                  var user =
                                      await userViewModel.signInEmailPassword(
                                          emailController.text,
                                          passwordController.text);
                                  if (userViewModel.user != null) {
                                    var usermodel = await userViewModel
                                        .readUser(user!.userID);
                                    if (mounted && usermodel!.status!) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LandingScreen()),
                                          (Route<dynamic> route) => false);
                                    } else {
                                      await userViewModel.signOut();
                                      if (mounted) {
                                        Navigator.of(
                                                context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LandingScreen()),
                                                (Route<dynamic> route) =>
                                                    false);

                                        buildShowModelBottomSheet(
                                            context,
                                            'Girmiş olduğunuz hesabınız, toplum kurallarına uygun olmayan davranışlarınız sebebiyle banlanmıştır.',
                                            Icons.report);
                                      }
                                    }
                                  } else {
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                      debugPrint('$errorMessage///////');
                                      buildShowModelBottomSheet(
                                          context,
                                          errorMessage,
                                          Icons.question_mark_outlined);
                                      errorMessage = '';
                                    }
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ))
                        ],
                      ).separated(const SizedBox(
                        height: 16,
                      )),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
