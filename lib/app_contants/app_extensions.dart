import 'package:flutter/material.dart';

extension FlexExtension on Flex {
  separated(Widget separator) {
    final iterator = this.children.iterator;

    if (!iterator.moveNext()) return this;

    final children = <Widget>[];
    children.add(iterator.current);

    while (iterator.moveNext()) {
      children.add(separator);
      children.add(iterator.current);
    }

    if (direction == Axis.horizontal) {
      return Row(
        key: key,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        children: children,
      );
    } else {
      return Column(
        key: key,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        children: children,
      );
    }
  }
}

extension ConvertTime on int {
  String formatSecond() {
    if (this >= 3600) {
      int saat = this ~/ 3600;
      int dakika = (this % 3600) ~/ 60;
      int saniye = this % 60;

      String saatString = saat.toString().padLeft(2, '0');
      String dakikaString = dakika.toString().padLeft(2, '0');
      String saniyeString = saniye.toString().padLeft(2, '0');

      return '$saatString:$dakikaString:$saniyeString';
    } else {
      int dakika = this ~/ 60;
      int saniye = this % 60;

      String dakikaString = dakika.toString().padLeft(2, '0');
      String saniyeString = saniye.toString().padLeft(2, '0');

      return '$dakikaString:$saniyeString';
    }
  }
}
