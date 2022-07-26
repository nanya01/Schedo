import 'package:flutter/material.dart';
import 'package:todo_app/global/global.dart';
import 'package:todo_app/view/authentication/login.dart';
import 'package:todo_app/view/mainScreens/home_screen.dart';
import 'package:todo_app/widgets/snackbar.dart';

class AuthenticatioWrapper extends StatefulWidget {
  const AuthenticatioWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticatioWrapperState createState() => _AuthenticatioWrapperState();
}

class _AuthenticatioWrapperState extends State<AuthenticatioWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          } else {
            Scaffold.of(context)
                .showSnackBar(snackBar("Network Error... please try again"));
            throw Exception();
          }
        });
  }
}
