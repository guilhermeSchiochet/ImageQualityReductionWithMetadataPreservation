import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

const _headerBytes = {
  'jpg' : [0xFF, 0xD8, 0xFF, 0xE1],
  'jpeg': [0xFF, 0xD8, 0xFF, 0xE0],
  'png' : [0x89, 0x50, 0x4E, 0x47],
};

class GetInfoImage extends GetxController {
  var name = ''.obs;
  var width = 0.obs;
  var height = 0.obs;
  var sizeMB = 0.0;
  var sizeKB = 0.0;
  var size = ''.obs;
  var mimeType = ''.obs;
  var headerBytes = <int>[];
  var headerBytesHex = ''.obs;

  GetInfoImage(File image, [String? filename]) {
    name.value = filename ?? p.basename(image.path);
    getMoreInfo(image);
  }

  GetInfoImage.fromRaw(Uint8List raw) {
    getInfoFromRaw(raw);
    mimeType.value = const ListEquality().equals(headerBytes, _headerBytes['png']) ? 'image/png' : 'image/jpeg';
  }

  void getMoreInfo(File image) {
    var raw = image.readAsBytesSync();
    getInfoFromRaw(raw);
    mimeType.value = lookupMimeType(image.path, headerBytes: headerBytes) ?? '<unknown>';
  }

  Future<void> getInfoFromRaw(Uint8List raw) async {
    var decodeImage = await decodeImageFromList(raw);
    width.value = decodeImage.width;
    height.value = decodeImage.height;
    var bytes = raw.lengthInBytes;
    sizeKB = bytes / 1024;
    sizeMB = sizeKB / 1024;
    setSize();
    headerBytes = raw.take(4).toList();
    headerBytesHex.value = headerBytes.map((e) => e.toRadixString(16).toUpperCase()).join(' ');
  }

  void setSize() {
    size.value = sizeMB >= 1.0 ? '${sizeMB.toStringAsFixed(2)} MB' : '${sizeKB.toStringAsFixed(2)} KB';
  }
}
