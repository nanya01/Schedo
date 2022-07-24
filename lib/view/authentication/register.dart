import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/firebaseMethods/auth_service.dart';
import 'package:todo_app/resources/colors_manager.dart';
import 'package:todo_app/view/authentication/login.dart';
import 'package:todo_app/widgets/error_dialog.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  void pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (c) {
            return const LoadingDialog(
              message: "Registering Account",
            );
          });
      String message = await _authService.signUpUser(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          passwordController.text,
          file: _image);

      if (message == "success") {
        Fluttertoast.showToast(msg: "Registered successfully");
        Future.delayed(const Duration(milliseconds: 20), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const LoginScreen()));
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 70,
              ),
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        _image == null ? null : FileImage(File(_image!.path)),
                    child: _image == null
                        ? Icon(
                            Icons.add_photo_alternate,
                            size: MediaQuery.of(context).size.width * 0.2,
                            color: Colors.grey,
                          )
                        : null),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                        data: Icons.person,
                        controller: firstNameController,
                        hintText: "first name",
                        validator: (value) => value!.isNotEmpty
                            ? null
                            : "This field cannot be empty"),
                    CustomTextField(
                        data: Icons.person,
                        controller: lastNameController,
                        hintText: "surname",
                        validator: (value) => value!.isNotEmpty
                            ? null
                            : "This field cannot be empty"),
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
                    CustomTextField(
                      data: Icons.lock,
                      controller: confirmPasswordController,
                      hintText: " Confirm Password",
                      isObscure: true,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (passwordController.text ==
                              confirmPasswordController.text) {
                            return null;
                          } else {
                            return "Passwords do not match";
                          }
                        } else {
                          return "This field cannot be empty";
                        }
                      },
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Already Registered?", children: [
                    TextSpan(
                        text: " Login",
                        style: const TextStyle(
                            color: ColorManager.blue, fontSize: 18),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => const LoginScreen()));
                          })
                  ])
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: ElevatedButton(
                  onPressed: () {
                    signUpUser();
                  },
                  //style: Theme.of(context).elevatedButtonTheme.style,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
