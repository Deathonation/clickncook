import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Scraper {
  static void getData() async {
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
  }
}

void main(List<String> arguments) {
  Scraper.getData();
}
