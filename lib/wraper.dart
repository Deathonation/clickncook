import 'package:clickncook/models/user_models.dart';
import 'package:clickncook/screens/home_screen.dart';
import 'package:clickncook/screens/login_screen.dart';
import 'package:clickncook/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wraper extends StatelessWidget {
  const Wraper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthServices authService = Provider.of<AuthServices>(context);
    return StreamBuilder<User>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User user = snapshot.data;
            return user == null
                ? LoginScreen()
                : HomePage(
                    searchtext: null,
                  );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
