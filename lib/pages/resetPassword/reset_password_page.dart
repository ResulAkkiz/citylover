import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/common_widgets/custom_model_sheet.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
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
                    onChanged: (value) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: 'E-mail', labelText: 'E-mail'),
                  ),

                  ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    child: const Text('Şifremi Sıfırla'),
                  )
                ],
              ).separated(const SizedBox(
                height: 16,
              )),
            ),
          ),
        ),
      ),
    );
  }
}
