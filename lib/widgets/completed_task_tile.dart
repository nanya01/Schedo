import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/global/global.dart';

import '../model/task.dart';
import '../resources/colors_manager.dart';

class CompletedTaskTile extends StatefulWidget {
  final String docID;
  final Task task;
  const CompletedTaskTile({required this.task, required this.docID, Key? key})
      : super(key: key);

  @override
  _CompletedTaskTileState createState() => _CompletedTaskTileState();
}

class _CompletedTaskTileState extends State<CompletedTaskTile> {
  IconData categoryIcon() {
    String category = widget.task.category;
    if (category == "study") {
      return Icons.school;
    } else if (category == "sport") {
      return Icons.emoji_events;
    } else if (category == "work") {
      return Icons.work;
    } else {
      return Icons.people;
    }
  }

  Color categoryIconColor() {
    String category = widget.task.category;
    if (category == "study") {
      return ColorManager.studyCategoryColor;
    } else if (category == "sport") {
      return ColorManager.sportsCategoryColor;
    } else if (category == "work") {
      return ColorManager.workCategoryColor;
    } else {
      return ColorManager.friendsCategoryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      decoration: const BoxDecoration(color: ColorManager.tileColor),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          if (direction == DismissDirection.endToStart) {
            return showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    title: const Text("Are you sure you want to delete?"),
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 20),
                    actionsOverflowButtonSpacing: 20,
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Back")),
                      ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(firebaseAuth.currentUser!.uid)
                                .collection("tasks")
                                .doc(widget.docID)
                                .delete();

                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Task deleted",
                                backgroundColor: ColorManager.errorColor);
                          },
                          child: const Text("Ok")),
                    ],
                    content: const Text("Click ok to continue"),
                  );
                });
          } else {
            return Fluttertoast.showToast(msg: "An error occurred");
          }
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.green,
          child: const Icon(Icons.archive_sharp, color: Colors.white, size: 32),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          color: ColorManager.errorColor,
          child: const Icon(
            Icons.delete,
            color: ColorManager.white,
          ),
        ),
        key: ObjectKey(widget.docID),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            Fluttertoast.showToast(
                msg: "Task deleted", backgroundColor: ColorManager.errorColor);
          }
        },
        child: ListTile(
          title: Text(widget.task.title,
              style: const TextStyle(
                color: ColorManager.white,
              )),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.watch_later,
                    color: ColorManager.white,
                  ),
                  Text(
                    widget.task.timeCreated,
                    style: const TextStyle(
                      color: ColorManager.white,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    categoryIcon(),
                    color: categoryIconColor(),
                  ),
                  Text(
                    widget.task.category,
                    style: const TextStyle(color: ColorManager.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
