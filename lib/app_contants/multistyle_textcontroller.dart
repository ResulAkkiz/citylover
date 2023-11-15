import 'package:flutter/material.dart';

class MultiStyleTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final textSpans = <TextSpan>[];

    final textLength = text.trim().length;
    const maxCharLimit = 1000;

    if (textLength > maxCharLimit) {
      final firstPart = TextSpan(
        text: text.substring(0, maxCharLimit),
        style: const TextStyle(color: Colors.black),
      );

      final secondPart = TextSpan(
        text: text.substring(maxCharLimit),
        style: TextStyle(
            backgroundColor: Colors.red.shade100, color: Colors.black),
      );

      textSpans.add(firstPart);
      textSpans.add(secondPart);
    } else {
      final singlePart = TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black),
      );

      textSpans.add(singlePart);
    }

    return TextSpan(children: textSpans);
  }
}
