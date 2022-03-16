import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import 'package:clickncook/pickImage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

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
    final URL = 'https://www.indianhealthyrecipes.com/?s=$value';
    final response = await http.get(URL);
    dom.Document document = parser.parse(response.body);
    setState(() {
      final title = document.getElementsByClassName('entry-header');
      titles =
          title.map((e) => e.getElementsByTagName("a")[0].innerHtml).toList();
      print(titles[0]);
      final link = document.getElementsByClassName(
          'authority-featured-image authority-image-aligncenter');
      links = link
          .map((e) => e.getElementsByTagName("a")[0].attributes['href'])
          .toList();
      print(links[0]);

      final images = document.getElementsByClassName('entry-image-link');
      imagesLinks = images
          .map((e) => e.getElementsByTagName("img")[0].attributes['src'])
          .toList();
    });

    // print(URL);
    // final response = await http.get(Uri.parse(URL));
    // final body = response.body;
    // final html = parse(body);
    // setState(() {
    //   result = html.querySelector('.entry-title-link').text;
    //   final image = html.querySelectorAll('.entry-title-link');
    //   print(image);
    //   print('Title: $result');
    // });

    // value = "pav bhaji";
    // value = value.replaceAll(' ', '-');
    //
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
      getData(textController.text);
      print(result);
    });
  }

  Widget bodyFunction() {
    switch (_page) {
      case 0:
        return Center(child: Text("HomePage"));

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "ClickNCook",
          style: TextStyle(fontSize: 29),
        ),
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: 20.0),
          //   child: IconButton(
          //       icon: Icon(Icons.search),
          //       onPressed: () async {
          //         showSearch(context: context, delegate: DataSearch());
          //       }),
          // )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Container(
                  width: 300,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Searh Dishes",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    controller: textController,
                    textAlign: TextAlign.start,
                    onSubmitted: (String x) {
                      setState(() {
                        getData(textController.text);
                        _page = 1;
                      });
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7.0, bottom: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.lightGreenAccent),
                      height: 40,
                      // color: Colors.lightGreenAccent,
                      child: IconButton(
                          icon: Icon(
                            Icons.search_outlined,
                            color: Colors.black45,
                            size: 28,
                          ),
                          onPressed: () {
                            getData(textController.text);
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
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.red,
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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    color: Colors.black38,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 5),
                            child: Text(
                              widget.titles[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[900],
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // Text(
                        //   widget.links[index],
                        // ),
                        SizedBox(
                          height: 15,
                        ),
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
