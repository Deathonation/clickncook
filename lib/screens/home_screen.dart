import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'package:clickncook/pickImage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  int _page = 0;
  String result = "";
  Future<String> ans;
  void getData(str) async {
    String value = str;
    // value = "pav bhaji";
    // value = value.replaceAll(' ', '-');
    final URL = 'https://www.indianhealthyrecipes.com/?s=$value';
    print(URL);
    final response = await http.get(Uri.parse(URL));
    // print("hiresponse $response");
    final body = response.body;
    // print("hibody $body");
    final html = parse(body);
    // print("hihtml $html");
    setState(() {
      result = html.querySelector('.entry-title-link').text;

      print('Title: $result');
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
        return HomePageContent(result: result);

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
        child: result == ""
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

class HomePageContent extends StatelessWidget {
  final String result;
  HomePageContent({
    Key key,
    @required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 500,
          width: 320,
          child: PageView(
            scrollDirection: Axis.horizontal,
            children: [
              SomeListView(result: this.result),
              SomeListView(result: this.result),
              SomeListView(result: this.result)
            ],
          ),
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
