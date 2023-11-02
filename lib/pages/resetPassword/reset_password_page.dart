import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/common_widgets/custom_back_button.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
import 'package:citylover/common_widgets/icon_elevated_button.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();
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
                    "Şifre Sıfırla",
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
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.bottomLeft,
            constraints:
                BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
            color: Colors.white,
            child: Image.asset(
              ImageEnum.pencil.toPath,
              scale: 1.8,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                      ),
                      IconElevatedButton(
                          text: 'Şifremi Sıfırla',
                          onPressed: emailController.text != ''
                              ? () async {
                                  bool isSuccesful = await userViewModel
                                      .resetPassword(emailController.text);
                                  if (isSuccesful && mounted) {
                                    buildShowModelBottomSheet(
                                        context,
                                        'Mail adresinize şifre sıfırlama için mail başarıyla gönderilmiştir.',
                                        Icons.mail);
                                  }
                                }
                              : null,
                          icon: const Icon(
                            Icons.email_rounded,
                            color: Colors.white,
                          )),
                    ],
                  ).separated(const SizedBox(
                    height: 16,
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
