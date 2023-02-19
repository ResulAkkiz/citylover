import 'package:citylover/pages/firstpage/first_page.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    debugPrint((userViewModel.user.toString()).toString());
    if (userViewModel.user == null) {
      debugPrint('FirstPage');
      return const FirstPage();
    } else {
      debugPrint('HomePage');
      return const HomePage();
    }
  }
}
