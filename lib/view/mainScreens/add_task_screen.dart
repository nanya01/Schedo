import 'package:flutter/material.dart';
import 'package:todo_app/resources/colors_manager.dart';
import 'package:todo_app/widgets/category_tile.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  void chooseCategory() {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: ColorManager.whiteWithOpacity,
                    )),
                const SizedBox(
                  width: 80,
                ),
                Text(
                  "New Task",
                  style: TextStyle(
                      color: ColorManager.whiteWithOpacity, fontSize: 20),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              style: TextStyle(color: ColorManager.white),
              maxLines: 5,
              decoration: InputDecoration(hintText: "Enter task"),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Choose Category",
              style: TextStyle(color: ColorManager.whiteWithOpacity),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryTile(
                    title: "Study",
                    onPressed: chooseCategory,
                    iconData: Icons.school,
                  ),
                  CategoryTile(
                    title: "Friends",
                    onPressed: chooseCategory,
                    iconData: Icons.people,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
