// import 'package:clickncook/searchdelegate.dart';

import 'package:clickncook/screens/home_screen.dart';
import 'package:clickncook/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:clickncook/utils/routes.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: MyRoutes.searchBarroute,
      routes: {
        "/": (context) => new LoginScreen(),
        MyRoutes.homepageroute: (context) => HomePage(),
        // MyRoutes.loginRoute: (context) => LoginPage(),
      },
    );
  }
}
