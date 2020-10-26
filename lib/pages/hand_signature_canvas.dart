import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

class HandSignatureCanvas extends StatefulWidget {
  final void Function(Uint8List image) onDone;

  const HandSignatureCanvas({Key key, @required this.onDone}) : super(key: key);

  @override
  _HandSignatureCanvasState createState() => _HandSignatureCanvasState();
}

class _HandSignatureCanvasState extends State<HandSignatureCanvas> {
  HandSignatureControl control = new HandSignatureControl(
    threshold: 5.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        child: Stack(
          children: [
            Container(
              width: 500,
              height: 500,
              child: HandSignaturePainterView(
                control: control,
                color: Colors.blueGrey,
                width: 1.0,
                maxWidth: 10.0,
                type: SignatureDrawType.shape,
              ),
            ),
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Write Hand Signature",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: RaisedButton(
                child: Text("OK"),
                onPressed: () async {
                  if (!control.isFilled) {
                    Navigator.pop(context);
                  } else {
                    ByteData image = await control.toImage();
                    widget.onDone(image.buffer.asUint8List());
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}