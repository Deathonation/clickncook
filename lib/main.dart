// import 'package:clickncook/searchBar.dart';

// import 'package:clickncook/searchButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_search_bar/flutter_search_bar.dart';

import 'package:clickncook/utils/routes.dart';
import 'package:clickncook/utils/scraper.dart';

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
                onPressed: () {
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

class DataSearch extends SearchDelegate<String> {
  final dishes = [
    "dhokla",
    "biryani",
    "chicken Tikka",
    "Pav Bhaji",
    "dahi vada"
  ];

  final recentDishes = ["biryani", "pav bhaji"];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            print(query);

            showResults(context);
          }),
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  String title = "";

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    Scraper.getData(query).then((result) {
      title = result;
      print("HELLO");
    });

    return Center(
      child: Container(
          width: 300,
          height: 500,
          child: Card(
            color: Colors.white,
            child: Text(title),
          )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestionList = query.isEmpty
        ? recentDishes
        : dishes.where((element) => element.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.food_bank),
        title: Text(suggestionList[index]),
        onTap: () {
          query = suggestionList[index];
        },
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DataSearch && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;

  @override
  String toString() => 'DataSearch(title: $title)';
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
