import 'package:flutter/material.dart';
import 'package:todo_app/resources/colors_manager.dart';

ThemeData getApplicationTheme(BuildContext context) {
  return ThemeData(
    unselectedWidgetColor: ColorManager.blue,
      scaffoldBackgroundColor: ColorManager.darkBackgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(8.0),
        hintStyle: TextStyle(color: ColorManager.whiteWithOpacity),
        //enabled border
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),

        // focused border
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),

        // error border

        // focused error border
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(ColorManager.blue),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        )),
        minimumSize: MaterialStateProperty.all<Size>(const Size.fromHeight(50)),
      )));
}
