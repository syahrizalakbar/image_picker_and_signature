import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureCanvas extends StatefulWidget {
  final void Function(Uint8List image) onDone;

  const SignatureCanvas({Key key, @required this.onDone}) : super(key: key);

  @override
  _SignatureCanvasState createState() => _SignatureCanvasState();
}

class _SignatureCanvasState extends State<SignatureCanvas> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        child: Stack(
          children: [
            Expanded(
              child: Signature(
                controller: _controller,
                width: size.width,
                backgroundColor: Colors.white,
              ),
            ),
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Write Signature",
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
                  if (_controller.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    Uint8List image = await _controller.toPngBytes();
                    widget.onDone(image);
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