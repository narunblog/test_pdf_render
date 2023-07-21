import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'file_picker_controller.dart';

class FilePickerPage extends ConsumerWidget {
  static const String title = 'ファイルピッカー';
  const FilePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pdfPickerProvider);
    const textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 360,
                height: 200,
                child: Center(
                  child: Text(
                    provider.fileName,
                    style: textStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    if (await provider.pickFileIsSuccess) {
                      const snackBar = SnackBar(content: Text('ピックしたよ！'));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      const snackBar = SnackBar(content: Text('ピックしなかったよ！'));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: const Text('ファイルを選択する'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 30,
                child: Text(provider.fileContents),
              ),
              if (provider.base64 != null)
                SizedBox(
                  height: 200,
                  width: 350,
                  child: Image.memory(
                    base64.decode(provider.base64!),
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
