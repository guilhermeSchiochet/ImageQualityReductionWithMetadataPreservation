import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'dart:typed_data';

class ModalPickerImage {
  static void exibeModal(
      BuildContext context, void Function(Uint8List?) selectImagem) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Selecionar imagem',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await selectPickerImage(context, selectImagem, ImageSource.gallery);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Lottie.asset(
                          'assets/json/gallery_animated.json',
                          width: 120,
                          height: 120,
                          repeat: false,
                        ),
                        const Text(
                          'Galeria',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await selectPickerImage(context, selectImagem, ImageSource.camera);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Lottie.asset(
                          'assets/json/camera_animated.json',
                          width: 140,
                          height: 120,
                          repeat: false,
                        ),
                        const Text(
                          'Câmera',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> selectPickerImage (BuildContext context, void Function(Uint8List?) selectImagem, ImageSource source) async {
    selectImagem(await _pickImage(source));
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  static Future<Uint8List?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      return pickedFile.readAsBytes();
    }
    return null;
  }
}
