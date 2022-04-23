import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
  String prediction;
  bool _loading = false;
  String url;
  var image;

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

  @override
  Widget build(BuildContext context) {
    final ImagePicker imgPicker = new ImagePicker();
    Future<String> getFoodImage(int i) async {
      // ignore: deprecated_member_use

      final _auth = FirebaseAuth.instance;
      String userEmail = _auth.currentUser.email;
      if (i == 0) {
        image = await imgPicker.getImage(source: ImageSource.camera);
      } else if (i == 1) {
        image = await imgPicker.getImage(source: ImageSource.gallery);
      }

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
      prediction = response.body;
      Map<String, dynamic> demodata = {prediction.replaceAll('"', ''): url};
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(userEmail);

      collectionReference
          .doc("imagesClick")
          .collection("ImagesClick")
          .add(demodata);
      setState(() {});
      return prediction;
    }

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
                                : Column(
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 300,
                                        child: Image.file(
                                          _image,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      _image == null
                                          ? Container()
                                          : prediction != null
                                              ? Text(
                                                  prediction.replaceAll(
                                                      '"', ""),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                )
                                              : Container(
                                                  child: Text(""),
                                                ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      )
                                    ],
                                  ),
                          ],
                        ))
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
                      getFoodImage(0);
                    });
                  },
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.add_a_photo),
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: () {
                    setState(() {
                      getFoodImage(1);
                    });
                  },
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.photo_album),
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
                                      searchtext: prediction.toString(),
                                    )));
                      }),
                )
              ],
            ),
          )),
    );
  }
}
