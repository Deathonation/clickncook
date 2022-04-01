// import 'package:clickncook/searchdelegate.dart';

import 'package:clickncook/screens/home_screen.dart';
import 'package:clickncook/screens/login_screen.dart';
import 'package:clickncook/services/auth_services.dart';
import 'package:clickncook/wraper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:clickncook/utils/routes.dart';
import 'package:provider/provider.dart';
// import 'dart:html';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
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
    return MultiProvider(
      providers: [
        Provider<AuthServices>(
          create: (_) => AuthServices(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // initialRoute: MyRoutes.searchBarroute,
        routes: {
          "/": (context) => new Wraper(),
          "/home": (context) => new HomePage(
                searchtext: null,
              ),
          MyRoutes.homepageroute: (context) => HomePage(
                searchtext: null,
              ),
          // MyRoutes.loginRoute: (context) => LoginPage(),
        },
      ),
    );
  }
}
