import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clickncook/searchBar.dart';

SearchBarDemoHome value;

// var recipe = value

class Scraper {
  static ValueNotifier<String> enterValue = ValueNotifier('');
  // const Scraper({Key key}) : super(key: key);
  void initState() {
    loadData();
  }

  loadData() async {
    print(enterValue.value + " ");
  }

  final URL = "https://www.indianhealthyrecipes.com/?s=${enterValue}";
}
