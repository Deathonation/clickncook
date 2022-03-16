import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Scrape extends StatefulWidget {
  Scrape({Key key, this.text}) : super(key: key);
  final String text;

  @override
  _ScrapeState createState() => _ScrapeState();
}

class _ScrapeState extends State<Scrape> {
  String passText = "";

  // @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Scraper.getData(widget.text).then((result) {
        passText = result;
      });
    });
    String value = "chicken biryani";
    // value = "pav bhaji";

    return SafeArea(
      child: Center(
        child: Container(
          child: ListTile(
            title: Text(passText),
          ),
        ),
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
    final image = html.querySelectorAll('.entry-title-link');
    print(image);

    print('Title: $title');
    return title;
  }

  void main() {
    Scraper.getData("biryani");
  }
}
