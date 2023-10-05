import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:metadata_preservation/src/utils/modal_picker_image.dart';
import 'dart:io';
import 'package:image/image.dart' as impImage;
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> qualityOptions = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

  int? selectedQuality = 100;

  Uint8List? _imageSelect;

  bool imagemIgual = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _body,
          qualityDropdown(),
          _executar(),
          _imageSelect != null
              ? Text(!imagemIgual
                  ? 'Imagem não contem os mesmos metadados'
                  : 'Imagem contem os mesmos metadados')
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _executar() {
    return ElevatedButton(
        onPressed: () async {
          Uint8List segundaImagem = await compressImage(_imageSelect!, 10);

          bool teste = await compareExifData(_imageSelect!, segundaImagem);

          print(teste);
        },
        child: null);
  }

  Widget qualityDropdown() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButton<int>(
        value: selectedQuality,
        elevation: 100,
        menuMaxHeight: 250,
        isDense: true,
        autofocus: true,
        enableFeedback: true,
        iconDisabledColor: Colors.grey.shade400,
        iconEnabledColor: Colors.grey.shade800,
        padding: const EdgeInsets.all(20.0),
        borderRadius: BorderRadius.circular(12),
        isExpanded: true,
        onChanged: (newValue) {
          setState(() {
            selectedQuality = newValue;
          });
        },
        items: qualityOptions.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value%', style: const TextStyle(fontSize: 17)),
          );
        }).toList(),
        underline: Container(), // Remove a linha abaixo do DropdownButton.
      ),
    );
  }

  Widget get _body {
    return GestureDetector(
      onTap: () {
        ModalPickerImage.exibeModal(
          context,
          (imageSelect) {
            setState(() {
              _imageSelect = imageSelect;
            });
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(30),
        child: DottedBorder(
          color: Colors.grey,
          strokeWidth: 3,
          dashPattern: const [10, 6],
          child: Container(
            height: 180,
            width: double.infinity,
            color: Colors.transparent,
            child: Icon(
              Icons.file_copy_outlined,
              color: Colors.grey.shade700,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> compressImage(Uint8List imagePath, int quality) async {
    final image = impImage.decodeImage(imagePath);

    final compressedImage = impImage.encodeJpg(image!, quality: quality);

    // Retorna a imagem com a qualidade reduzida (com os metadados)
    return compressedImage;
  }

  Future<bool> compareExifData(
      Uint8List originalImageData, Uint8List compressedImageData) async {
    final originalExifData = await readExifFromBytes(originalImageData);
    final compressedExifData = await readExifFromBytes(compressedImageData);

    return originalExifData.toString() == compressedExifData.toString();
  }
}
