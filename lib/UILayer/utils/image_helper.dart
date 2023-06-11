import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageHelper {
  static Future<File> compressImage(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 60,
    );
    if (result != null) {
      var compressedFile = await file.writeAsBytes(result);
      return compressedFile;
    } else {
      return file;
    }
  }
}
