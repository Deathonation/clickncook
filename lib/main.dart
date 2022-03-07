// import 'package:clickncook/searchdelegate.dart';

import 'package:clickncook/screens/login_screen.dart';
import 'package:clickncook/utils/scraper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:clickncook/utils/routes.dart';
import 'package:clickncook/pickImage.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: MyRoutes.searchBarroute,
      routes: {
        "/": (context) => new LoginScreen(),
        MyRoutes.homepageroute: (context) => HomePage(),
        // MyRoutes.loginRoute: (context) => LoginPage(),
      },
    );
  }
}

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
        return Text(result);

        break;
      default:
        return Container(child: Text("nothing"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          borderRadius: BorderRadius.circular(20),
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
        child: Text("Image Search"),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
