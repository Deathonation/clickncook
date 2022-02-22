import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Scraper {
  static getData(str) async {
    String value = str;
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
