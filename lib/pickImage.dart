import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:clickncook/screens/home_screen.dart';

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
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final ImagePicker imgPicker = new ImagePicker();
  QuerySnapshot snapshot;
  Future<String> getImage() async {
    // ignore: deprecated_member_use

    final _auth = FirebaseAuth.instance;
    String userEmail = _auth.currentUser.email;

    var image = await imgPicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    _image = File(image.path);

    var datetime = DateTime.now();
    final ref = FirebaseStorage.instance
        .ref("myimages")
        .child(userEmail)
        .child("$datetime");

    await ref.putFile(_image);
    url = await ref.getDownloadURL();
    print(url);

    final response = await http.post(
        Uri.parse("https://ed8d-203-194-99-28.in.ngrok.io/modelapi/"),
        body: {"img_link": url});
    print(response.body);
    final prediction = response.body;
    Map<String, dynamic> demodata = {prediction.replaceAll('"', ''): url};
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(userEmail);

    collectionReference
        .doc("imagesClick")
        .collection("ImagesClick")
        .add(demodata);

    // final data = await FirebaseFirestore.instance
    //     .collection(userEmail)
    //     .doc("imagesClick")
    //     .collection("ImagesClick")
    //     .get();

    // print(data.docs.length);
    // print(data.docs[data.docs.length - 1].data());
    // final imgLinkJson = data.docs[data.docs.length - 1].data();
    // // final imgLink = imgLinkJson["images"];
    // print(imgLinkJson);

    // final cache = DefaultCacheManager();
    // await cache.emptyCache();
    setState(() {});
    return prediction;
  }

  @override
  Widget build(BuildContext context) {
    Future<String> prediction;
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
                                    child: Column(
                                      children: [
                                        Image.file(
                                          _image,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(prediction.toString())
                                      ],
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
                  onPressed: () {
                    setState(() {
                      prediction = getImage();
                    });
                  },
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