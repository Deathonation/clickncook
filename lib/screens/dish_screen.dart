import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DishDesc extends StatefulWidget {
  final List<String> imageLinks;
  final List<String> links;
  final List<String> titles;
  final int index;
  DishDesc({
    Key? key,
    required this.index,
    required this.imageLinks,
    required this.links,
    required this.titles,
  }) : super(key: key);

  @override
  State<DishDesc> createState() => _DishDescState();
}

class _DishDescState extends State<DishDesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ClickNCook"),
        ),
        body: widget.imageLinks == null
            ? Center(
                child: CircleAvatar(
                  radius: 30.0,
                  foregroundColor: Colors.red,
                ),
              )
            : Container(
                child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      widget.titles[widget.index],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListBody(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          dynamic url = widget.links[widget.index];
                          print(widget.links[widget.index]);
                          // print(!await canLaunch(url));
                          if (!await canLaunch(url)) {
                            print("inside");
                            await launch(url);
                          } else
                            print("ERROR launching url");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(color: Colors.black38, blurRadius: 20)
                            ]),
                            child: Image.network(
                              widget.imageLinks[widget.index],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Possible Ingredients: "),
                      )
                    ],
                  )
                ],
              )));
  }
}
