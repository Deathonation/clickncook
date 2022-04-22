import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:clickncook/screens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String passOutput;
  String url;

  @override
  void initState() {
    super.initState();
    // _loading = true;

    // loadModel().then((value) {
    setState(() {
      _loading = false;
    });
    // });
  }

  // loadModel() async {
  //   await Tflite.loadModel(
  //       model: "assets/model.tflite",
  //       labels: "assets/labels.txt",
  //       numThreads: 1);
  // }

  // loadModel() async {
  //   await Tflite.loadModel(
  //       model: "assets/mobilenet1/converted_model.tflite",
  //       labels: "assets/mobilenet1/labels.txt",
  //       numThreads: 1);
  // }

  // loadModel() async {
  //   await Tflite.loadModel(
  //       model: "assets/nishantmodel/model.tflite",
  //       labels: "assets/nishantmodel/labels.txt",
  //       numThreads: 1);
  // }

  // loadModel() async {
  //   await Tflite.loadModel(
  //       model: "assets/resnet/model.tflite",
  //       labels: "assets/resnet/labelsResnet.txt",
  //       numThreads: 1);
  // }

  // classifyImage(File image) async {
  //   var output = await Tflite.runModelOnImage(
  //     path: image.path,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //     numResults: 2,
  //     threshold: 0.2,
  //   );

  //   setState(() {
  //     _loading = false;
  //     _outputs = output;
  //     passOutput = _outputs[0]['label'];
  //   });
  // }

  final ImagePicker imgPicker = new ImagePicker();
  QuerySnapshot snapshot;
  Future getImage() async {
    // ignore: deprecated_member_use
    final _auth = FirebaseAuth.instance;
    String userEmail = _auth.currentUser.email;

    var image = await imgPicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      print(
          "null image BAKA-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
      return null;
    }
    setState(() {
      // _loading = true;
      _image = File(image.path);
    });
    // classifyImage(_image);
    print(
        "after classify BAKA-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    var datetime = DateTime.now();
    final ref = FirebaseStorage.instance
        .ref("myimages")
        .child(userEmail)
        .child("$datetime");

    await ref.putFile(_image);
    url = await ref.getDownloadURL();
    print(
        "after ref BAKA-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");

    Map<String, dynamic> demodata = {"images": url};

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(userEmail);
    print(
        "after CR BAKA-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    collectionReference
        .doc("imagesClick")
        .collection("ImagesClick")
        .add(demodata);

    print(
        "after all BAKA-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");

    final data = await FirebaseFirestore.instance
        .collection(userEmail)
        .doc("imagesClick")
        .collection("ImagesClick")
        .get();
    snapshot = data;
    print(snapshot.docs.length);
    print(snapshot.docs[snapshot.docs.length - 1].data());
    final imgLinkJson = snapshot.docs[snapshot.docs.length - 1].data();
    final imgLink = imgLinkJson["images"];
    print(imgLink);

    final response = await http.post(
        Uri.parse("https://f19f-203-194-99-28.in.ngrok.io/modelapi/"),
        body: {"img_link": imgLink});
    print(response.body.replaceAll('"', ""));
  }

  @override
  Widget build(BuildContext context) {
    // void getUserEmail() async {
    //   User user = await _auth.currentUser.email;
    // }

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
                            _image == null
                                ? Container(
                                    child: Text("Error no image"),
                                  )
                                : Container(
                                    height: 300,
                                    width: 300,
                                    child: Image.file(
                                      _image,
                                    ),
                                  ),
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