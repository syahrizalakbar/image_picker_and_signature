import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_test_image_picker/pages/hand_signature_canvas.dart';
import 'package:flutter_app_test_image_picker/pages/signature_canvas.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  var _pickImageError;

  Uint8List signature;
  var _pickSignatureError;

  Uint8List handSignature;
  var _pickHandSignatureError;

  Future<void> takePhoto() async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera
      );
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> writeSignature() async {
    try {
      await showDialog(
        context: context,
        builder: (context) {
          return SignatureCanvas(onDone: (Uint8List image) {
            setState(() {
              signature = image;
            });
          });
        },
      );
    } catch (e) {
      _pickSignatureError = e.toString();
    }
  }

  Future<void> writeHandSignature() async {
    try {
      await showDialog(
        context: context,
        builder: (context) {
          return HandSignatureCanvas(onDone: (Uint8List image) {
            setState(() {
              handSignature = image;
            });
          });
        },
      );
    } catch (e) {
      _pickHandSignatureError = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Home Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  MaterialButton(
                    child: Text("Take Photo"),
                    onPressed: takePhoto,
                  ),
                  _imageFile == null ? Text("Belum dipilih") : Image.file(_imageFile, width: 100, height: 100,),
                  _pickImageError != null ? Text(_pickImageError.toString() ?? "") : Text("-"),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  MaterialButton(
                    child: Text("Write Signature"),
                    onPressed: writeSignature,
                  ),
                  signature == null ? Text("Belum ditulis") :Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.grey ,spreadRadius: 1, blurRadius: 4),
                      ],
                      image: signature == null
                          ? null
                          : DecorationImage(
                        image: MemoryImage(signature),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  _pickSignatureError != null ? Text(_pickSignatureError.toString() ?? "") : Text("-"),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  MaterialButton(
                    child: Text("Write Hand Signature"),
                    onPressed: writeHandSignature,
                  ),
                  handSignature == null ? Text("Belum ditulis") :Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.grey ,spreadRadius: 1, blurRadius: 4),
                      ],
                      image: handSignature == null
                          ? null
                          : DecorationImage(
                        image: MemoryImage(handSignature),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  _pickHandSignatureError != null ? Text(_pickHandSignatureError.toString() ?? "") : Text("-"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}