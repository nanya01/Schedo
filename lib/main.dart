import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/resources/colors_manager.dart';
import 'package:todo_app/resources/theme_manager.dart';
import 'package:todo_app/view/authentication/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: getApplicationTheme(context),
              home: const SplashScreen(),
            ));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AuthenticatioWrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.5.w,
                child: Image.asset(
                  "assets/images/todo_logo.jpg",
                )),
            SizedBox(
              height: 10.h,
            ),
            const Text(
              "Schedo",
              style: TextStyle(
                  color: ColorManager.darkBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Save all tasks and access them from anywhere",
                style: TextStyle(
                    fontSize: 16, color: ColorManager.whiteWithOpacity),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
