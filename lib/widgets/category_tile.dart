import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: widget.backgroundColor,
        ),
        height: 30.h,
        width: 100.w,
        margin: EdgeInsets.only(right: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: SizedBox(
          width: 80.w,
          child: Row(
            children: [
              Icon(
                widget.iconData,
                color: widget.iconDataColor,
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(color: ColorManager.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
