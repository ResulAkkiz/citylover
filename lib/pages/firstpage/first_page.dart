import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/pages/authentication/login_page.dart';
import 'package:citylover/pages/authentication/signup_page.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    items: const [
                      DropdownMenuItem(
                        child: Text('Ülke'),
                      )
                    ],
                    onChanged: (value) {},
                  ),
                  DropdownButtonFormField<String>(
                    items: const [
                      DropdownMenuItem(
                        child: Text('Şehir'),
                      )
                    ],
                    onChanged: (value) {},
                  )
                ],
              ).separated(
                const SizedBox(
                  height: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignupPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    child: const Text('Üye Ol'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    child: const Text('Oturum Aç'),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  child: const Text('Üye olmadan devam et...'))
            ],
          ).separated(
            const SizedBox(
              height: 36,
            ),
          ),
        ),
      ),
    ));
  }
}
