import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/firebaseMethods/auth_service.dart';
import 'package:todo_app/global/global.dart';
import 'package:todo_app/view/authentication/register.dart';

import '../../resources/colors_manager.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/snackbar.dart';
import '../mainScreens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    if (await dataConnection.checkConnectivity()) {
      if (_formKey.currentState!.validate()) {
        showDialog(
            context: context,
            builder: (c) {
              return const LoadingDialog(
                message: "Checking Credentials",
              );
            });
        String message = await _authService.loginUser(
            emailController.text, passwordController.text);
        if (message == "success") {
          Fluttertoast.showToast(msg: "Login successfully");
          Future.delayed(const Duration(milliseconds: 20), () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const HomeScreen()));
          });
        } else if (message == "email or password is empty") {
          showDialog(
              context: context,
              builder: (c) {
                Navigator.pop(context);
                return const ErrorDialog(
                  message: "email or password is empty",
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                Navigator.pop(context);
                return ErrorDialog(
                  message: message,
                );
              });
        }
      }
    } else {
      Scaffold.of(context)
          .showSnackBar(snackBar("Network Error... please try again"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5.w,
                  child: Image.asset("assets/images/todo_logo.jpg")),
              SizedBox(
                height: 10.h,
              ),
              const Text(
                "Welcome to Schedo",
                style: TextStyle(
                    color: ColorManager.darkBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Login to your account to save all tasks and access them from anywhere",
                  style: TextStyle(
                      fontSize: 14, color: ColorManager.whiteWithOpacity),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      data: Icons.email,
                      controller: emailController,
                      hintText: "Email",
                      textInputType: TextInputType.emailAddress,
                      validator: (value) => value!.isNotEmpty
                          ? null
                          : "This field cannot be empty",
                    ),
                    CustomTextField(
                        data: Icons.lock,
                        controller: passwordController,
                        hintText: "Password",
                        isObscure: true,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (value.length >= 6) {
                              return null;
                            } else {
                              return "password must contain 6 characters";
                            }
                          } else {
                            return "This field cannot be empty";
                          }
                        }),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Don't have an account? ", children: [
                    TextSpan(
                        text: " Sign Up",
                        style: TextStyle(
                            color: ColorManager.blue, fontSize: 18.sp),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        const RegisterScreen()));
                          })
                  ])
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50.w,
                child: ElevatedButton(
                  onPressed: () {
                    loginUser();
                  },
                  //style: Theme.of(context).elevatedButtonTheme.style,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
