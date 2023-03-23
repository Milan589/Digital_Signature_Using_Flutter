import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepal_digit/screens/drawpreview.dart';
import 'package:signature/signature.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  late SignatureController controller;

  @override
  void initState() {
    super.initState();

    controller = SignatureController(
      penStrokeWidth: 15,
      penColor: Colors.white,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Nepali Digit Classification"),
          backgroundColor: Colors.redAccent,
        ),
        body: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Draw here as you requires',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            Container(
              width: 350,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 92, 80, 80),
                      offset: Offset(3.0, 3.0),
                      blurRadius: 2.0,
                    )
                  ]),
              child: Signature(
                controller: controller,
                backgroundColor: const Color.fromARGB(255, 211, 129, 129),
                height: 400,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buttons(context),
          ],
        ),
      );
  Widget buttons(BuildContext context) => Container(
        color: Colors.redAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            successButton(context),
            clearButton(),
          ],
        ),
      );

  Widget successButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.check, color: Colors.green),
        iconSize: 50,
        onPressed: () async {
          if (controller.isNotEmpty) {
            final signature = await exportSignature();

            // ignore: use_build_context_synchronously
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DrawPreview(
                signature: signature,
              ),
            ));

            controller.clear();
          }
        },
      );

  Widget clearButton() => IconButton(
        iconSize: 36,
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () => controller.clear(),
      );

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 15,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }

  void setOrientation(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}
