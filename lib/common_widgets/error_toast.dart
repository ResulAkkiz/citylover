import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

void showErrorToast(String text, BuildContext context) {
  MotionToast.error(
      barrierColor: Colors.black38,
      borderRadius: 30,
      animationType: AnimationType.fromLeft,
      animationCurve: Curves.easeInOutCirc,
      toastDuration: const Duration(milliseconds: 1500),
      animationDuration: const Duration(milliseconds: 500),
      enableAnimation: false,
      iconType: IconType.cupertino,
      description: Text(
        text,
        style: const TextStyle(color: Colors.white),
      )).show(context);
}
