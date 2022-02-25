import 'package:clickncook/utils/scraper.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  final dishes = [
    "dhokla",
    "biryani",
    "chicken Tikka",
    "Pav Bhaji",
    "dahi vada"
  ];

  final recentDishes = ["biryani", "pav bhaji"];

  String title = "";
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
      IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          showResults(context);
          print("query" + query);
          Scraper.getData(query).then((result) {
            this.title = result;
            print(result);
          });

          print("query1" + query);
        },
      ),
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

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return Center(
      child: Container(
        width: 400,
        height: 500,
        child: ListTile(
          tileColor: Colors.white,
          title: Text(this.title),
        ),
      ),
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

class Scraper {
  static getData(str) async {
    String value = str;
    // value = "pav bhaji";
    value = value.replaceAll(' ', '-');
    final URL = 'https://www.indianhealthyrecipes.com/?s=$value';
    print(URL);
    final response = await http.get(Uri.parse(URL));
    print("hiresponse $response");
    final body = response.body;
    print("hibody $body");
    final html = parse(body);
    print("hihtml $html");

    String title = html.querySelector('.entry-title-link').text;

    print('Title: $title');
    return title;
  }
}
