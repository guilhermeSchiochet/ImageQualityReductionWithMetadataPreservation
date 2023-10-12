import 'dart:typed_data';

import 'package:exif/exif.dart';

class StandardValidations {
  
  ///
  ///
  ///
  static Future<bool> validateMetadataPresentInCompressedImage(Uint8List originalImageData, Uint8List compressedImageData) async {
    final Map<String, IfdTag> originalExifData = await readExifFromBytes(originalImageData);
    final Map<String, IfdTag> compressedExifData = await readExifFromBytes(compressedImageData);

    for (final key in originalExifData.keys) {
      final originalValue = originalExifData[key];
      final compressedValue = compressedExifData[key];

      if (originalValue != compressedValue) {
        return false;
      }
    }

    return true;
  }

  ///
  ///
  ///
  static Future<bool> compareExifData( Uint8List originalImageData, Uint8List compressedImageData) async {
    final originalExifData = await readExifFromBytes(originalImageData);
    final compressedExifData = await readExifFromBytes(compressedImageData);

    return originalExifData.toString() == compressedExifData.toString();
  }
}