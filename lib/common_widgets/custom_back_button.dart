import 'package:citylover/app_contants/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          elevation: 8,
          backgroundColor: ThemeColors.primary400,
          shape: const StadiumBorder()),
      onPressed: () {
        Navigator.maybePop(context);
      },
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white,
      ),
      label: const Text(
        "Geri",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }
}
