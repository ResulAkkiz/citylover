import 'dart:io';

import 'package:citylover/app_contants/string_generator.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<File> processImage(File photoFile) async {
    img.Image? image =
        img.decodeImage(photoFile.readAsBytesSync()); // reading the image
    img.Image squareImage = img.copyResizeCropSquare(image!,
        size: 300); //crop the image and resize to square
    img.Image blurImage =
        img.gaussianBlur(squareImage, radius: 24); // apply gaussingBlur

    List<int> blurImageBytes = img.encodePng(blurImage);
    String tempPath = (await getTemporaryDirectory()).path;
    File blurImageFile = File('$tempPath/${getRandomString(7)}');
    await blurImageFile.writeAsBytes(blurImageBytes);

    return blurImageFile;
  }
}
