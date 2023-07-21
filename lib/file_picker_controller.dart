import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_render/pdf_render.dart';

final pdfPickerProvider =
    ChangeNotifierProvider.autoDispose<PdfPickerController>(
  (ref) => PdfPickerController(),
);

class PdfPickerController extends ChangeNotifier {
  PdfPickerController();

  bool pickSuccess = false;
  File? file;
  String fileName = '選択したファイル名がここに表示されます';
  String fileContents = 'ファイルの中身がここに表示されます';
  Image? image;
  String? base64;

  /// このプロバイダーが廃棄されるよきに呼ばれる
  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> get pickFileIsSuccess async {
    final filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // ピックする拡張子を限定できる。
    );
    if (filePickerResult != null) {
      pickSuccess = true;
      file = File(filePickerResult.files.single.path!);
      fileName = filePickerResult.files.single.name;
      final doc = await PdfDocument.openFile(file!.path);
      try {
        final page = await doc.getPage(1);
        final pdfPageImage = await page.render();
        final image = await pdfPageImage.createImageDetached();
        final imgBytes = await image.toByteData(format: ImageByteFormat.png);
        final List<int> imageData = imgBytes!.buffer.asUint8List();
        base64 = base64Encode(imageData);
      } finally {
        doc.dispose();
      }
    } else {
      pickSuccess = false;
      file = null;
      fileName = '何も選択されませんでした';
      fileContents = 'ファイルの中身がここに表示されます';
    }
    notifyListeners();
    return pickSuccess;
  }
}
