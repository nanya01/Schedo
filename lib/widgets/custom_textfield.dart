import 'package:flutter/material.dart';
import 'package:todo_app/resources/colors_manager.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  final String? Function(String?)? validator;
  bool? isObscure;
  bool? enabled;
  TextInputType? textInputType;

  CustomTextField(
      {this.controller,
      this.data,
      this.hintText,
      this.isObscure = false,
      this.enabled = true,
      this.validator,
      this.textInputType = TextInputType.text,
      Key? key})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorManager.darkBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(color: ColorManager.white),
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
        enabled: widget.enabled,
        controller: widget.controller,
        obscureText: widget.isObscure!,
        cursorColor: Theme.of(context).primaryColor,
        validator: widget.validator,
        keyboardType: widget.textInputType,
      ),
    );
  }
}
