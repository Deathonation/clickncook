import 'package:clickncook/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecentSearch extends StatefulWidget {
  const RecentSearch({Key key}) : super(key: key);

  @override
  _RecentSearchState createState() => _RecentSearchState();
}

class _RecentSearchState extends State<RecentSearch> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    String userEmail = _auth.currentUser.email;
    Stream<QuerySnapshot> userinfo = FirebaseFirestore.instance
        .collection(userEmail)
        .doc("recentsearch")
        .collection("recentSearches")
        .snapshots();

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                child: Text(
              "SEARCH HISTORY",
              style: TextStyle(fontSize: 25),
            )),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black38,
              child: StreamBuilder<QuerySnapshot>(
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

                    return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                          searchtext: data.docs[index]
                                                  ['dishname']
                                              .toString())));
                            },
                            child: ListTile(
                              title: Text(
                                "${data.docs[index]['dishname'].toString()}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
