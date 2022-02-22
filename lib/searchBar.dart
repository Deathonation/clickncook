// import 'package:clickncook/utils/scraper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class SearchBarDemoHome extends StatefulWidget {
  @override
  _SearchBarDemoHomeState createState() => new _SearchBarDemoHomeState();
}

class _SearchBarDemoHomeState extends State<SearchBarDemoHome> {
  TextEditingController textEditingController = TextEditingController();
  String searchText;
  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();

  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('D:/searchbar.txt');
  // }

  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Search Bar Demo'),
        actions: [searchBar.getSearchAction(context)]);
  }

  String onSubmit(String value) {
    setState(() {
      Scraper.enterValue.value = textEditingController.text;
      // final response = await http.get('http://127.0.0.1:5000/api');
      // final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    });
    // => _scaffoldKey.currentState
    //     .showSnackBar(new SnackBar(content: new Text('You wrote $value!')))
    return Scraper.enterValue.value;
  }

  _SearchBarDemoHomeState() {
    searchBar = new SearchBar(
      controller: textEditingController,
      inBar: false,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmit,
      onCleared: () {
        print("cleared");
      },
      onClosed: () {
        print("closed");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: searchBar.build(context), key: _scaffoldKey, body: Scraper());
  }
}

class Scraper extends StatelessWidget {
  const Scraper({Key key}) : super(key: key);
  static ValueNotifier<String> enterValue = ValueNotifier('');
  Future<String> getData(String value) async {
    var value = 'chicken biryani recipe';
    value = value.replaceAll(' ', '-');
    final URL = 'https://www.indianhealthyrecipes.com/?s=$value';
    print(URL);
    final response = await http.get(Uri.parse(URL));
    print("hiresponse $response");
    final body = response.body;
    print("hibody $body");
    final html = parse(body);
    print("hihtml $html");

    final title = html.querySelector('.entry-title-link').text;

    print('Title: $title');
    return title;
  }

  @override
  Widget build(BuildContext context) {
    Future<String> title = getData(Scraper.enterValue.value);
    return Container(
      child: Text(title.toString()),
    );
  }
}
