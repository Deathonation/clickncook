import 'dart:convert';
import 'package:clickncook/utils/scraper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  void onSubmit(String value) {
    Scraper.enterValue.value = textEditingController.text;

    setState(() {
      // final response = await http.get('http://127.0.0.1:5000/api');
      // final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    });
    // => _scaffoldKey.currentState
    //     .showSnackBar(new SnackBar(content: new Text('You wrote $value!')))
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
        appBar: searchBar.build(context),
        key: _scaffoldKey,
        body: new Center(
          // child: new Text("Don't look at me! Press the search button!")),
          child: (searchText != null)
              ? Container(
                  width: 300,
                  height: 400,
                  child: Text(searchText),
                )
              : Text("no data"),
        ));
  }
}
