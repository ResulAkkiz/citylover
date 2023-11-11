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

    if (userViewModel.firebaseUser == null) {
      return const FirstPage();
    } else {
      return const HomePage();
    }
  }
}
