import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/firebaseMethods/cloud_firestore_service.dart';
import 'package:todo_app/resources/colors_manager.dart';
import 'package:todo_app/view/mainScreens/home_screen.dart';
import 'package:todo_app/widgets/category_tile.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final CloudFirestoreService _cloudFirestoreService = CloudFirestoreService();
  String category = "study";
  String? title;

  chooseCategory(String yourCategory) {
    setState(() {
      category = yourCategory;
    });
  }

  addTask() {
    if (_formKey.currentState!.validate()) {
      _cloudFirestoreService.setTask(title!, category);
      Fluttertoast.showToast(msg: "Task added successfully");
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
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
                  SizedBox(
                    width: 80.w,
                  ),
                  Text(
                    "New Task",
                    style: TextStyle(
                        color: ColorManager.whiteWithOpacity, fontSize: 20.sp),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                    style: const TextStyle(color: ColorManager.white),
                    maxLines: 5,
                    decoration: const InputDecoration(hintText: "Enter task"),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                    validator: (val) =>
                        val!.isNotEmpty ? null : "This field cannot be empty"),
              ),
              SizedBox(
                height: 50.h,
              ),
              Text(
                "Choose Category",
                style: TextStyle(color: ColorManager.whiteWithOpacity),
              ),
              SizedBox(
                height: 20.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryTile(
                      backgroundColor:
                          category == "study" ? ColorManager.blue : null,
                      title: "Study",
                      onPressed: () => chooseCategory("study"),
                      iconData: Icons.school,
                      iconDataColor: ColorManager.studyCategoryColor,
                    ),
                    CategoryTile(
                      backgroundColor:
                          category == "sport" ? ColorManager.blue : null,
                      title: "Sport",
                      onPressed: () => chooseCategory("sport"),
                      iconData: Icons.emoji_events,
                      iconDataColor: ColorManager.sportsCategoryColor,
                    ),
                    CategoryTile(
                      backgroundColor:
                          category == "work" ? ColorManager.blue : null,
                      title: "Work",
                      onPressed: () => chooseCategory("work"),
                      iconData: Icons.work,
                      iconDataColor: ColorManager.workCategoryColor,
                    ),
                    CategoryTile(
                      backgroundColor:
                          category == "friends" ? ColorManager.blue : null,
                      title: "Friends",
                      onPressed: () => chooseCategory("friends"),
                      iconData: Icons.people,
                      iconDataColor: ColorManager.friendsCategoryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              ElevatedButton(onPressed: addTask, child: const Text("Add Task"))
            ],
          ),
        ),
      ),
    ));
  }
}
