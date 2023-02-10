import 'package:citylover/app_contants/custom_theme.dart';
import 'package:citylover/pages/firstpage/first_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: customTheme,
      debugShowCheckedModeBanner: false,
      home: const FirstPage(),
    );
  }
}
