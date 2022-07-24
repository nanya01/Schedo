import 'package:flutter/material.dart';

import '../resources/colors_manager.dart';

class CategoryTile extends StatefulWidget {
  IconData? iconData;
  String title;
  final VoidCallback onPressed;
  Color? iconDataColor;
  Color? backgroundColor;

  CategoryTile(
      {this.iconData,
      required this.title,
      this.iconDataColor,
      required this.onPressed,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        color: widget.backgroundColor,
        child: Row(
          children: [
            Icon(
              widget.iconData,
              color: widget.iconDataColor,
            ),
            Text(
              widget.title,
              style: const TextStyle(color: ColorManager.white),
            )
          ],
        ),
      ),
    );
  }
}
