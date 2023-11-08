import 'package:flutter/material.dart';

enum ImageEnum {
  register,
  city,
  profile,
  cloud,
  nodata,
  accessibility,
  pencil,
  user,
  enter,
  signin,
  paper
}

extension ImageEnumExtension on ImageEnum {
  String get toPath => "assets/images/${name}_ic.png";
  Widget get toImage => Image.asset(toPath);
}
