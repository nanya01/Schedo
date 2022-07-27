import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/global/global.dart';
import 'package:todo_app/view/authentication/login.dart';
import 'package:todo_app/view/mainScreens/home_screen.dart';
import 'package:todo_app/widgets/progress_bar.dart';

import '../../viewModel/home_viewmodel.dart';

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
            Provider.of<HomeViewModel>(context, listen: false)
                .fetchUserDetails();
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            // else if (snapshot.hasError) {
            //   return Center(
            //     child: Text('${snapshot.error}'),
            //   );
            // }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgress();
          }
          return const LoginScreen();
        });
  }
}
