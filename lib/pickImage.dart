import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageSearch extends StatefulWidget {
  const ImageSearch({Key key}) : super(key: key);

  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  File _image;

  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _image == null ? Text("HOME") : Image.file(_image),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          backgroundColor: Colors.grey,
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}
