import 'package:citylover/app_contants/custom_theme.dart';
import 'package:citylover/locator/locator.dart';
import 'package:citylover/pages/splashpage/splash_page.dart';
import 'package:citylover/viewmodel/add_sharing_viewmodel.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:citylover/viewmodel/user_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaceViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddSharingViewModel(),
        )
      ],
      child: MaterialApp(
        theme: customTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
