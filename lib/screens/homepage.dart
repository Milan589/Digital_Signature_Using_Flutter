import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nepal_digit/screens/capture.dart';
import 'package:nepal_digit/screens/takeImage.dart';
import 'httpservice.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HttpService _httpService = HttpService();
  // final DioService _dioService = DioService();
  late CameraDescription _cameraDescription;
  List<String> _images = [];
  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print(err);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nepali Digit Classification"),
          backgroundColor: Colors.redAccent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 400,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                            CaputreImage(
                              onTap: () async {
                                final String? imagePath =
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => TakeImage(
                                                  camera: _cameraDescription,
                                                )));

                                print('imagepath: $imagePath');
                                if (imagePath != null) {
                                  setState(() {
                                    _images.add(imagePath);
                                  });
                                }
                              },
                            ),
                          ] +
                          _images
                              .map((String path) => CaputreImage(
                                    imagePath: path,
                                  ))
                              .toList()),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  // color: Colors.indigo,
                                  gradient: LinearGradient(colors: [
                                    Colors.redAccent.shade400,
                                    Colors.redAccent.shade700
                                  ]),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(3.0))),
                              child: RawMaterialButton(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                onPressed: () async {
                                  // show loader
                                  presentLoader(context, text: 'Wait...');

                                  // // calling with dio
                                  // var responseDataDio =
                                  //     await _dioService.uploadPhotos(_images);

                                  // calling with http
                                  var responseDataHttp =
                                      await _httpService.uploadPhotos(_images);

                                  // hide loader
                                  Navigator.of(context).pop();

                                  // showing alert dialogs
                                  // await presentAlert(context,
                                  //     title: 'Success Dio',
                                  //     message: responseDataDio.toString());
                                  await presentAlert(context,
                                      title: 'Success HTTP',
                                      message: responseDataHttp);
                                },
                                child: const Center(
                                    child: Text(
                                  'SEND',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                )),
                              )),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
