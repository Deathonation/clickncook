import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:clickncook/screens/home_screen.dart';

import 'package:tflite/tflite.dart';

class ImageSearch extends StatefulWidget {
  const ImageSearch({Key key}) : super(key: key);

  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  File _image;
  List _outputs;
  bool _loading = false;
  String passOutput = "";

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);

    setState(() {
      _loading = false;
      _outputs = output;
      passOutput = _outputs[0]['label'];
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  final ImagePicker imgPicker = new ImagePicker();
  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await imgPicker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _loading
                    ? Container(
                        height: 300,
                        width: 300,
                      )
                    : Container(
                        margin: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _image == null ? Container() : Image.file(_image),
                            SizedBox(
                              height: 20,
                            ),
                            _image == null
                                ? Container()
                                : _outputs != null
                                    ? Text(
                                        _outputs[0]['label'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      )
                                    : Container(
                                        child: Text(""),
                                      ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
          floatingActionButton: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                new FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: getImage,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.add_a_photo),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 80,
                  width: 100,
                  child: new FloatingActionButton(
                      heroTag: "btn2",
                      tooltip: "look for it",
                      child: Text("look for it"),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new HomePage(
                                      searchtext: passOutput,
                                    )));
                      }),
                )
              ],
            ),
          )),
    );
  }
}

// FloatingActionButton(
//           tooltip: "pick Image",
//           onPressed: getImage,
//           backgroundColor: Colors.grey,
//           child: Icon(Icons.add_a_photo),