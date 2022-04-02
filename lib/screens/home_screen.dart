import 'package:clickncook/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clickncook/pickImage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.searchtext}) : super(key: key);
  final String searchtext;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> titles;
  List<String> links;
  List<String> imagesLinks;
  final textController = TextEditingController();

  int _page = 0;
  String result = "";
  Future<String> ans;

  void getData(str) async {
    String value = str;
    final url = 'https://www.indianhealthyrecipes.com/?s=$value';
    final response = await http.get(Uri.parse(url));
    dom.Document document = parser.parse(response.body);
    setState(() {
      final title = document.getElementsByClassName('entry-header');
      titles =
          title.map((e) => e.getElementsByTagName("a")[0].innerHtml).toList();
      print(titles.isEmpty ? null : titles[0]);

      final link = document.getElementsByClassName(
          'authority-featured-image authority-image-aligncenter');
      links = link
          .map((e) => e.getElementsByTagName("a")[0].attributes['href'])
          .toList();
      // print(links[0]);

      final images = document.getElementsByClassName('entry-image-link');
      imagesLinks = images
          .map((e) => e.getElementsByTagName("img")[0].attributes['src'])
          .toList();
    });
  }
  // imagepicker code

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  bool typing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      getData(textController.text.trim());
      print(result);
    });
  }

  Widget bodyFunction() {
    switch (_page) {
      case 0:
        return HomePageContent(
          result: result,
          imagesLinks: imagesLinks,
          links: links,
          titles: titles,
        );

        break;
      case 1:
        return HomePageContent(
          result: result,
          imagesLinks: imagesLinks,
          links: links,
          titles: titles,
        );

        break;
      default:
        return Container(child: Text("nothing"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context);
    final _auth = FirebaseAuth.instance;
    String userEmail = _auth.currentUser.email;

    // void getUserEmail() async {
    //   User user = await _auth.currentUser.email;
    // }

    void addData(str) {
      Map<String, dynamic> demodata = {"dishname": str};

      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(userEmail);

      collectionReference
          .doc("recentsearch")
          .collection("recentSearches")
          .add(demodata);
      // collectionReference.snapshots().listen((event) {
      //   setState(() {
      //     final data = event.docs[0].data();
      //     print(data);
      //   });
      // });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.grey.withOpacity(0.6),
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => new HomePage(searchtext: null)));
          },
          child: Center(
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  child: Image.asset(
                    "assets/images/ClickNCookLogo.png",
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "ClickNCook",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.history),
              onPressed: () async {
                await authService.signOut();
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authService.signOut();
              })
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Container(
                  width: 300,
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Searh Dishes",
                              filled: true,
                              contentPadding:
                                  EdgeInsets.only(left: 12, bottom: 5)),
                          controller: textController,
                          textAlign: TextAlign.start,
                          onSubmitted: (String x) {
                            final String str = textController.text.trim();
                            getData(str);
                            addData(str);
                            setState(() {
                              _page = 1;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7.0, bottom: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.redAccent),
                      height: 40,
                      child: IconButton(
                          icon: Icon(
                            Icons.search_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            final String str = textController.text.trim();
                            getData(str);
                            addData(str);
                            setState(() {
                              _page = 1;
                            });
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: titles == null
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : bodyFunction(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ImageSearch())),
          backgroundColor: Colors.grey,
          child: Icon(Icons.camera_alt_outlined)),
    );
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}

class HomePageContent extends StatefulWidget {
  final String result;
  final List<String> titles;
  final List<String> links;
  final List<String> imagesLinks;
  HomePageContent({
    Key key,
    @required this.result,
    @required this.imagesLinks,
    @required this.links,
    @required this.titles,
  }) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.6),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          itemCount: widget.links.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                dynamic url = widget.links[index];
                print(widget.links[index]);
                // print(!await canLaunch(url));
                if (!await canLaunch(url)) {
                  print("inside");
                  await launch(url);
                } else
                  print("ERROR launching url");
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.white.withOpacity(0.6),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(15.0),
                  // ),
                  child: Container(
                    color: Colors.transparent.withOpacity(0.3),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 10),
                            child: Text(
                              widget.titles[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.network(widget.imagesLinks[index]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SomeListView extends StatelessWidget {
  final String result;
  const SomeListView({Key key, @required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Card(
        child: new Center(
            child: ListView(
          children: [
            ListTile(title: Text(result)),
            ListBody(
              children: [
                Image.network(
                  "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80",
                  height: 310,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 12, top: 8),
                  child: Text("Description:  $result"),
                )
              ],
            )
          ],
        )),
      ),
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 20.0,
          ),
        ],
      ),
    );
  }
}
