import 'package:flutter/material.dart';

import '../resources/colors_manager.dart';

SnackBar snackBar(String msg) {
  final snackBar =
      SnackBar(content: Text(msg), backgroundColor: (ColorManager.errorColor));

  return snackBar;
}
