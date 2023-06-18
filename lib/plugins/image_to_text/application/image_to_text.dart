import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

class ImageToText {
  // late TextRecognizer _textRecognizer;

  Future<String> recognize() async {
  //   _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  //
  //   final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     return _processImage(File(pickedFile.path));
  //   }
  //
    return "Nothing recognized";
  }

  Future<String> _processImage(File imageFile) async {
    // // final inputImage = InputImage.fromFilePath(imageFile.path);
    // final recognisedText = await _textRecognizer.processImage(inputImage);
    //
    // _textRecognizer.close();
    //
    return "recognisedText.text";
  }
}