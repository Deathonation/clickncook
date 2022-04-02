import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyEndDrawer extends StatefulWidget {
  const MyEndDrawer({Key key}) : super(key: key);

  @override
  State<MyEndDrawer> createState() => _MyEndDrawerState();
}

class _MyEndDrawerState extends State<MyEndDrawer> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    String userEmail = _auth.currentUser.email;
    Stream<QuerySnapshot> userinfo = FirebaseFirestore.instance
        .collection(userEmail)
        .doc("name")
        .collection("Name")
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: userinfo,
        builder: (
          context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text("something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }
          final data = snapshot.requireData;

          return Drawer(
            child: ListView(children: [
              DrawerHeader(
                  child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      data.docs[0]['FirstName'].toString(),
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      data.docs[0]['LastName'].toString(),
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              )),
              ListTile(
                title: Text(userEmail),
                trailing: Icon(Icons.mail),
              )
            ]),
          );
        });
  }
}
