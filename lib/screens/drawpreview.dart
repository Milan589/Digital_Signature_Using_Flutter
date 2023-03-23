import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nepal_digit/screens/httpservice.dart';
import 'package:permission_handler/permission_handler.dart';
import '../display.dart';

class DrawPreview extends StatelessWidget {
  final Uint8List? signature;

  DrawPreview({
    Key? key,
    required this.signature,
  }) : super(key: key);
  final HttpService _httpService = HttpService();
  List<String> _signature = [];

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
              icon: const Icon(Icons.send),
              onPressed: () => sendHttp(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Center(
              child: Image.memory(signature!, width: double.infinity),
            ),
            RawMaterialButton(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              onPressed: () async {
                // show loader
                presentLoader(context, text: 'Wait...');

                // calling with http
                var responseDataHttp =
                    await _httpService.uploadPhotos(_signature);

                // hide loader
                Navigator.of(context).pop();

                await presentAlert(context,
                    title: 'Success HTTP', message: responseDataHttp);
              },
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SEND',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
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

  Future sendHttp(BuildContext context) async {
    var responseDataHttp = await _httpService.uploadPhotos(_signature);
  }

  Future<void> presentAlert(BuildContext context,
      {String title = '', String message = '', Function()? ok}) {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text('$title'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text('$message'),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  // style: greenText,
                ),
                onPressed: ok != null ? ok : Navigator.of(context).pop,
              ),
            ],
          );
        });
  }

  void presentLoader(BuildContext context,
      {String text = 'Aguarde...',
      bool barrierDismissible = false,
      bool willPop = true}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Row(
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
          );
        });
  }
}
