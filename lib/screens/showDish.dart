import 'package:clickncook/screens/home_screen.dart';
import 'package:flutter/material.dart';

class DishDesc extends StatefulWidget {
  const DishDesc({Key key}) : super(key: key);

  @override
  State<DishDesc> createState() => _DishDescState();
}

class _DishDescState extends State<DishDesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey,
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => new HomePage(searchtext: null)));
          },
          child: Center(
            child: Text(
              "ClickNCook",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
        actions: [Image.asset("assets/images/ClickNCookLogo.png")],
      ),
      body: Container(
        child: Text("Yo dish description"),
      ),
    );
  }
}
