import 'package:clickncook/searchdelegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:clickncook/utils/routes.dart';

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
        "/": (context) => new HomePage(),
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
  bool typing = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Start the application"),
        // actions: [GoToSearch()],
        // title: typing ? TextBox() : Text("ClickNCook"),
        title: Text("ClickNCook"),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  showSearch(context: context, delegate: DataSearch());
                }),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: Text("Our Scarped Files yoyo"),
          ),
        ),
      ),
    );
  }
}



// class TextBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
//       width: 400,
//       alignment: Alignment.centerLeft,
//       color: Colors.white,
//       child: TextField(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: BorderSide(
//               width: 0,
//               style: BorderStyle.none,
//             ),
//           ),
//           hintText: 'Search',
//         ),
//       ),
//     );
//   }
// }
