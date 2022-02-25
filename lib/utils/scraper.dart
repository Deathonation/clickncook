import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Scrape extends StatefulWidget {
  const Scrape({Key key}) : super(key: key);

  @override
  _ScrapeState createState() => _ScrapeState();
}

class _ScrapeState extends State<Scrape> {
  final SearchText;
  String passText = "";

  _ScrapeState(this.SearchText);
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Scraper.getData("chicken Biryani").then((result) {
      this.passText = result;
      print(this.passText + " LOL");
      setState(() {});
    });

    return Container(
      child: ListTile(
        title: Text(this.passText),
      ),
    );
  }
}

class Scraper {
  static getData(str) async {
    String value = str;
    // value = "pav bhaji";
    value = value.replaceAll(' ', '-');
    final URL = 'https://www.indianhealthyrecipes.com/?s=$value';
    print(URL);
    final response = await http.get(Uri.parse(URL));
    // print("hiresponse $response");
    final body = response.body;
    // print("hibody $body");
    final html = parse(body);
    // print("hihtml $html");

    String title = html.querySelector('.entry-title-link').text;

    print('Title: $title');
    return title;
  }
// void main() {
//   Scraper.getData("str");
// }
}
