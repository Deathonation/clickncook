// import 'package:clickncook/searchdelegate.dart';
import 'dart:io';

import 'package:clickncook/screens/login_screen.dart';
import 'package:clickncook/utils/scraper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:clickncook/utils/routes.dart';
import 'package:clickncook/pickImage.dart';
import 'package:image_picker/image_picker.dart';

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

  // imagepicker code

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  bool typing = false;

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {});
  // }

  Widget bodyFunction() {
    switch (_page) {
      case 0:
        return Center(child: Text("HomePage"));

        break;
      case 1:
        setState(() {});
        return Scrape(
          text: textController.text,
        );

        break;
      default:
        return Container(child: Text("nothing"));
    }
  }

  String text = "";
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
        child: bodyFunction(),
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
