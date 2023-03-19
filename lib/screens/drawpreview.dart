import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import '../display.dart';

class DrawPreview extends StatelessWidget {
  final Uint8List? signature;

  const DrawPreview({
    Key? key,
    required this.signature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: const CloseButton(),
          title: const Text('Store Picture'),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () => storePicture(context),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.abc_sharp),
              onPressed: () async{
                var responseDataHttp =
                                      await _httpService.uploadPhotos(_images);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: Image.memory(signature!, width: double.infinity),
        ),
      );

  Future storePicture(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'digit_$time.png';

    final result = await ImageGallerySaver.saveImage(signature!, name: name);
    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      SetClear.clearBar(
        context,
        text: 'Saved to signature folder',
        color: Colors.green,
      );
    } else {
      SetClear.clearBar(
        context,
        text: 'Failed to save signature',
        color: Colors.red,
      );
    }
  }
}
